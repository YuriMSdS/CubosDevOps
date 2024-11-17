resource "docker_network" "private_network" {
  name = "private_network"
}
resource "docker_container" "postgre" {
  name  = "db"
  image = "postgres:15"

  volumes {
    host_path      = "C:/Users/Administrador/Desktop/CubosDevOps/src/app/sql"
    container_path = "/usr/src/app/sql/script.sql"
  }

  volumes {
    host_path      = "C:/Users/Administrador/Desktop/CubosDevOps/src/app/sql/data"
    container_path = "/var/lib/postgresql/data"
  }

  ports {
    internal = 5432
    external = 5432
  }
  env = [
    "POSTGRES_HOST=db",
    "POSTGRES_USERNAME=${var.db_username}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_NAME=postgres",
    "PGDATA=/var/lib/postgresql/data"
  ]
  restart = "on-failure"
  privileged = true      
  networks_advanced {
    name = docker_network.private_network.name
  }
}

resource "docker_container" "frontend" {
  name  = "web_container"
  image = "nginx:latest"
  entrypoint = ["nginx", "-g", "daemon off;"]
  ports {
    internal = 80
    external = 8080
  }

  volumes {
    host_path      = "C:/Users/Administrador/Desktop/CubosDevOps/src/app/front/index.html"
    container_path = "/usr/share/nginx/html/index.html"
  }

  volumes {
    host_path      = "C:/Users/Administrador/Desktop/CubosDevOps/src/app/back/script.js"
    container_path = "/usr/src/app/back/script.js"
  }

  networks_advanced {
    name = docker_network.private_network.name
  }
}

resource "docker_container" "backend_container" {
  name  = "backend_container"
  image = "node:16"
  entrypoint = ["/bin/sh", "-c", "sleep 10 && node /usr/src/app/back/script.js"]

  volumes {
    host_path      = "C:/Users/Administrador/Desktop/CubosDevOps/src/app/back"
    container_path = "/usr/src/app/back/script.js"
  }

  volumes {
    host_path      = "C:/Users/Administrador/Desktop/CubosDevOps/src/app/sql/script.sql"
    container_path = "/usr/src/app/sql/script.sql"
  }

  env = [
    "PORT=3000",
    "DATABASE_HOST=db",
    "DATABASE_PORT=5432",
    "DATABASE_NAME=postgres",
    "POSTGRESQL_USERNAME=${var.db_username}",
    "POSTGRESQL_PASSWORD=${var.db_password}"
  ]

  ports {
    internal = 3000
    external = 3000
  }

  networks_advanced {
    name = docker_network.private_network.name
  }

  depends_on = [docker_container.postgre]
}