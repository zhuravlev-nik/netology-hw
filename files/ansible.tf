locals {
  web_vms = [
    for vm in yandex_compute_instance.web :
    {
      name        = vm.name
      external_ip = vm.network_interface[0].nat_ip_address
      fqdn        = vm.fqdn
    }
  ]

  db_vms = [
    for vm in yandex_compute_instance.db :
    {
      name        = vm.name
      external_ip = vm.network_interface[0].nat_ip_address
      fqdn        = vm.fqdn
    }
  ]

  storage_vm = [
    {
      name        = yandex_compute_instance.storage.name
      external_ip = yandex_compute_instance.storage.network_interface[0].nat_ip_address
      fqdn        = yandex_compute_instance.storage.fqdn
    }
  ]
}

resource "local_file" "ansible_inventory" {
  filename = "${path.module}/inventory.ini"

  content = templatefile("${path.module}/inventory.tmpl", {
    webservers = local.web_vms
    databases  = local.db_vms
    storage    = local.storage_vm
  })
}
