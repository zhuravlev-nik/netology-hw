resource "random_password" "root" {
  length  = 16
  special = false
}

resource "random_password" "wordpress" {
  length  = 16
  special = false
}

resource "docker_image" "mysql" {
  name         = "mysql:8"
  keep_locally = false
}

resource "docker_container" "mysql" {
  name  = "mysql_test"
  image = docker_image.mysql.name

  ports {
    internal = 3306
    external = 3306
  }
  env = [
    "MYSQL_ROOT_PASSWORD=${random_password.root.result}",
    "MYSQL_DATABASE=wordpress",
    "MYSQL_USER=wordpress",
    "MYSQL_PASSWORD=${random_password.wordpress.result}",
    "MYSQL_ROOT_HOST=%"
  ]
}
