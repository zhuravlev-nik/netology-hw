vms_resources = {
  web = {
    cores         = 2,
    memory        = 1,
    core_fraction = 5,
    platform_id   = "standard-v1",
  },
  db = {
    cores         = 2,
    memory        = 2,
    core_fraction = 20,
    platform_id   = "standard-v1",
  }
}

metadata = {
  serial-port-enable = 1
  ssh-keys           = "ubuntu:***"
}
