resource "yandex_vpc_network" "develop" {
  name = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name           = var.vpc_name
  zone           = var.default_zone
  network_id     = yandex_vpc_network.develop.id
  v4_cidr_blocks = var.default_cidr
}

output "test" {
  value = {
    all     = [for i in range(1, 100) : "rc${i}"],
    exclude = [for i in range(1, 100) : "rc${i}" if !contains(["0", "7", "8", "9"], substr(tostring(i), length(tostring(i)) - 1, 1)) || i == 19]
  }
}
