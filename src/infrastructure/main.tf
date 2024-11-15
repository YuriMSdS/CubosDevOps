resource "docker_network" "private_network" {
  name = "internal_network"
}

resource "docker_container" "frontend" {
  name  = "web_container"
  image = "nginx:latest"

  ports {
    internal = 80
    external = 8080
  }

  volumes {
    host_path      = "${path.module}/../app/front/index.html"
    container_path = "/usr/share/nginx/html/index.html"
  }

  volumes {
    host_path      = "${path.module}/../app/back/script.js"
    container_path = "/usr/src/app/script.js"
  }

  networks_advanced {
    name = docker_network.private_network.name
  }
}

resource "docker_container" "backend_container" {
  name  = "backend_container"
  image = "node:16"

  entrypoint = ["/bin/bash", "/usr/src/app/start.sh"]

   volumes = [
    {
      host_path      = "${path.module}/../app/back/script.js"
      container_path = "/usr/src/app/script.js"
    },
    {
      host_path      = "${path.module}/../app/back/package.json"
      container_path = "/usr/src/app/package.json"
    },
    {
      host_path      = "${path.module}/../app/back/start.sh"
      container_path = "/usr/src/app/start.sh"
    },
    {
      host_path      = "${path.module}/../app/back/wait-for-db.sh"
      container_path = "/usr/src/app/wait-for-db.sh"
    }
  ]

  networks_advanced {
    name = docker_network.private_network.name
  }

  env = [
    "PORT=3000",
    "DATABASE_HOST=db",
    "DATABASE_PORT=5432",
    "DATABASE_NAME=db",
    "POSTGRESQL_USERNAME=${var.db_username}",
    "POSTGRESQL_PASSWORD=${var.db_password}"
  ]
  
  depends_on = [docker_container.postgre]
}

resource "docker_image" "postgre" {
  name = "bitnami/postgresql:15.8"
}

resource "docker_container" "postgre" {
  name  = "db"
  image = docker_image.postgre.image_id

   volumes {
    host_path      = "${path.module}/../app/sql/data"
    container_path = "/bitnami/postgresql/data"
  }

  env = [
    "POSTGRESQL_DATABASE=db",
    "POSTGRESQL_USERNAME=${var.db_username}",
    "POSTGRESQL_PASSWORD=${var.db_password}"
  ]

  networks_advanced {
    name = docker_network.private_network.name
  }

  restart = "on-failure"
}
