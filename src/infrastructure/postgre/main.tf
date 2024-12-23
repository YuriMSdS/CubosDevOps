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