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