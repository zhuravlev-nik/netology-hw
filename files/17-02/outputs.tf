output "vm_instances_info" {
  value = {
    web = {
      name        = yandex_compute_instance.platform.name
      external_ip = yandex_compute_instance.platform.network_interface[0].nat_ip_address
      fqdn        = yandex_compute_instance.platform.fqdn
    }
    db = {
      name        = yandex_compute_instance.netology-develop-platform-db.name
      external_ip = yandex_compute_instance.netology-develop-platform-db.network_interface[0].nat_ip_address
      fqdn        = yandex_compute_instance.netology-develop-platform-db.fqdn
    }
  }
}
