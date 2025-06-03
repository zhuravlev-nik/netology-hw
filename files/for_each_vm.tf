locals {
  ssh_key     = file(var.ssh_key_path)
  each_vm_map = { for vm in var.each_vm : vm.vm_name => vm }
}

resource "yandex_compute_instance" "db" {
  for_each = local.each_vm_map

  name        = each.key
  platform_id = "standard-v1"
  zone        = var.default_zone

  resources {
    cores  = each.value.cpu
    memory = each.value.ram
  }

  boot_disk {
    initialize_params {
      image_id = "fd827b91d99psvq5fjit"
      size     = each.value.disk_volume
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${local.ssh_key}"
  }
}
