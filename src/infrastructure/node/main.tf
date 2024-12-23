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