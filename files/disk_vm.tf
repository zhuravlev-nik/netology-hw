resource "yandex_compute_disk" "storage_disks" {
  count = 3
  name  = "storage-disk-${count.index + 1}"
  size  = 1
  zone  = var.default_zone
}

resource "yandex_compute_instance" "storage" {
  name        = "storage"
  platform_id = "standard-v1"
  zone        = var.default_zone

  resources {
    cores  = 2
    memory = 2
  }

  boot_disk {
    initialize_params {
      image_id = "fd827b91d99psvq5fjit"
      size     = 10
    }
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.develop.id
    nat       = true
  }

  metadata = {
    ssh-keys = "ubuntu:${file(var.ssh_key_path)}"
  }

  dynamic "secondary_disk" {
    for_each = { for disk in yandex_compute_disk.storage_disks : disk.name => disk }
    content {
      disk_id = secondary_disk.value.id
    }
  }
}
