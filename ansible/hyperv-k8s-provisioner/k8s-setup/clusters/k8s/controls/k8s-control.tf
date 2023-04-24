variable "state" { default = "Running" }

terraform {
  required_version = ">= 1.4.2"
  required_providers {
    hyperv = {
      # source = "taliesins/hyperv"
      source  = "local/taliesins/hyperv"
      version = "1.0.4"
    }
  }
}

provider "hyperv" {
  user     = <user>
  password = <password>
  host     = <host>
  # https       = true
  insecure = true
  # use_ntlm    = true
  # script_path = "C:/Users/<user>/AppData/Local/Temp/"
  timeout     = "600s"
}

data "hyperv_network_switch" "k8s_network_switch" {
  name = "k8s"
}

# resource "hyperv_network_switch" "k8s_network_switch" {
#   name = "k8s"
# }

# # Internal Load Balancer
# resource "hyperv_vhd" "k8s_lb_vhd_0" {
#   path = "C:\\K8sImages\\k8s(alpine)\\k8s-lb\\k8s-lb-disk-0.vhdx" #Needs to be absolute path
#   size = 10737418240                                              #10GB
#   block_size = 1048576                                             #1MB
# }

# resource "hyperv_machine_instance" "k8s_lb" {
#   name                   = "k8s-lb"
#   path                   = "C:\\K8sImages\\k8s(alpine)\\"
#   generation             = 2
#   processor_count        = 2
#   dynamic_memory         = true
#   memory_startup_bytes   = 536870912 #512MB 2^29
#   memory_maximum_bytes   = 536870912 #512MB 2^29
#   memory_minimum_bytes   = 134217728 #128MB 2^27
#   wait_for_state_timeout = 10
#   wait_for_ips_timeout   = 10
#   # state                  = "Off"
#   state                  = "${var.state}"

#   vm_firmware {
#     enable_secure_boot = "Off"
#     # boot_order {
#     #   boot_type = "HardDiskDrive"
#     #   controller_number     = 0
#     #   controller_location   = 0
#     # }
#     # boot_order {
#     #   boot_type = "DvdDrive"
#     #   controller_number     = 0
#     #   controller_location   = 1
#     # }
#     # boot_order {
#     #   boot_type = "DvdDrive"
#     #   controller_number     = 0
#     #   controller_location   = 2
#     # }
#     # boot_order {
#     #   boot_type             = "NetworkAdapter"
#     #   network_adapter_name  = "k8s"
#     # }
#   }

#   vm_processor {
#     expose_virtualization_extensions = true
#   }

#   network_adaptors {
#     # dynamic_mac_address= false
#     name               = hyperv_network_switch.k8s_network_switch.name
#     # static_mac_address = "00:00:10:00:00:02"
#     switch_name        = hyperv_network_switch.k8s_network_switch.name
#     wait_for_ips       = false
#   }

#   dvd_drives {
#     controller_number   = 0
#     controller_location = 1
#     path                = "C:\\Users\\<user>\\Downloads\\alpine-extended-3.17.1-x86_64.iso"
#     resource_pool_name  = "Primordial"
#   }

#   dvd_drives {
#     controller_number   = 0
#     controller_location = 2
#     path                = "C:\\Users\\<user>\\Downloads\\k8s-lb-seed.iso"
#     resource_pool_name  = "Primordial"
#   }

#   hard_disk_drives {
#     controller_type     = "Scsi"
#     path                = hyperv_vhd.k8s_lb_vhd_0.path
#     controller_number   = 0
#     controller_location = 0
#     resource_pool_name  = "Primordial"
#   }
# }

# Control Node 0
resource "hyperv_vhd" "k8s_control_0_vhd_0" {
  path = "C:\\K8sImages\\k8s(ubuntu)\\k8s-control-0\\k8s-control-0-disk-0.vhdx" #Needs to be absolute path
  size = 68719476736                                                            #64GB
  block_size = 1048576                                                           #1MB
}

resource "hyperv_vhd" "k8s_control_0_vhd_1" {
  path = "C:\\K8sImages\\k8s(ubuntu)\\k8s-control-0\\k8s-control-0-disk-1.vhdx" #Needs to be absolute path
  size = 10737418240                                                            #10GB
  block_size = 1048576                                                           #1MB
}

resource "hyperv_vhd" "k8s_control_0_vhd_2" {
  path = "C:\\K8sImages\\k8s(ubuntu)\\k8s-control-0\\k8s-control-0-disk-2.vhdx" #Needs to be absolute path
  size = 107374182400                                                            #100GB
  block_size = 1048576                                                           #1MB
}

resource "hyperv_machine_instance" "k8s_control_0" {
  name                          = "k8s-control-0"
  path                          = "C:\\K8sImages\\k8s(ubuntu)\\"
  # path                          = "C:\\K8sImages\\k8s(alpine)\\"
  generation                    = 2
  processor_count               = 6
  dynamic_memory                = true
  guest_controlled_cache_types  = true
  high_memory_mapped_io_space   = 34896609280 #33280MB (2^20)*33280
  low_memory_mapped_io_space    = 3221225472 #3GB (2^30)*3
  memory_startup_bytes          = 12884901888 #12288MB (2^33)+(2^32)
  memory_maximum_bytes          = 12884901888 #12288MB (2^33)+(2^32)
  # memory_minimum_bytes          = 268435456 #256MB 2^28
  memory_minimum_bytes          = 12884901888 #12288MB (2^33)+(2^32)
  wait_for_state_timeout        = 10
  wait_for_ips_timeout          = 10
  # state                         = "Off"
  state                         = "${var.state}"

  vm_firmware {
    # enable_secure_boot = "On"
    enable_secure_boot = "Off"
    secure_boot_template = "MicrosoftUEFICertificateAuthority"
    # boot_order {
    #   boot_type = "HardDiskDrive"
    #   controller_number     = 0
    #   controller_location   = 0
    # }
    # boot_order {
    #   boot_type = "HardDiskDrive"
    #   controller_number     = 0
    #   controller_location   = 1
    # }
    # boot_order {
    #   boot_type = "HardDiskDrive"
    #   controller_number     = 0
    #   controller_location   = 2
    # }
    # boot_order {
    #   boot_type = "DvdDrive"
    #   controller_number     = 0
    #   controller_location   = 3
    # }
    # boot_order {
    #   boot_type = "DvdDrive"
    #   controller_number     = 0
    #   controller_location   = 4
    # }
    # boot_order {
    #   boot_type             = "NetworkAdapter"
    #   network_adapter_name  = "k8s"
    # }
  }

  vm_processor {
    expose_virtualization_extensions = true
  }

  network_adaptors {
    # dynamic_mac_address= false
    name               = data.hyperv_network_switch.k8s_network_switch.name
    # static_mac_address = "00:00:10:00:00:03"
    switch_name        = data.hyperv_network_switch.k8s_network_switch.name
    wait_for_ips       = false
  }
  dvd_drives {
    controller_number   = 0
    controller_location = 3
    path                = "C:\\Users\\<user>\\Downloads\\ubuntu-22.04.1-live-server-amd64-autoinstall.iso"
    # path                = "C:\\Users\\<user>\\Downloads\\alpine-virt-3.16.2-x86_64.iso"
    resource_pool_name  = "Primordial"
  }

  dvd_drives {
    controller_number   = 0
    controller_location = 4
    path                = "C:\\Users\\<user>\\Downloads\\k8s-control-0-seed.iso"
    resource_pool_name  = "Primordial"
  }

  hard_disk_drives {
    controller_type     = "Scsi"
    path                = hyperv_vhd.k8s_control_0_vhd_0.path
    controller_number   = 0
    controller_location = 0
    resource_pool_name  = "Primordial"
  }

  hard_disk_drives {
    controller_type     = "Scsi"
    path                = hyperv_vhd.k8s_control_0_vhd_1.path
    controller_number   = 0
    controller_location = 1
    resource_pool_name  = "Primordial"
  }

  hard_disk_drives {
    controller_type     = "Scsi"
    path                = hyperv_vhd.k8s_control_0_vhd_2.path
    controller_number   = 0
    controller_location = 2
    resource_pool_name  = "Primordial"
  }
}

# Control Node 1
resource "hyperv_vhd" "k8s_control_1_vhd_0" {
  path = "C:\\K8sImages\\k8s(ubuntu)\\k8s-control-1\\k8s-control-1-disk-0.vhdx" #Needs to be absolute path
  size = 68719476736                                                            #64GB
  block_size = 1048576                                                           #1MB
}

resource "hyperv_vhd" "k8s_control_1_vhd_1" {
  path = "C:\\K8sImages\\k8s(ubuntu)\\k8s-control-1\\k8s-control-1-disk-1.vhdx" #Needs to be absolute path
  size = 10737418240                                                            #10GB
  block_size = 1048576                                                           #1MB
}

resource "hyperv_vhd" "k8s_control_1_vhd_2" {
  path = "C:\\K8sImages\\k8s(ubuntu)\\k8s-control-1\\k8s-control-1-disk-2.vhdx" #Needs to be absolute path
  size = 107374182400                                                            #100GB
  block_size = 1048576                                                           #1MB
}

resource "hyperv_machine_instance" "k8s_control_1" {
  name                          = "k8s-control-1"
  path                          = "C:\\K8sImages\\k8s(ubuntu)\\"
  # path                          = "C:\\K8sImages\\k8s(alpine)\\"
  generation                    = 2
  processor_count               = 6
  dynamic_memory                = true
  guest_controlled_cache_types  = true
  high_memory_mapped_io_space   = 34896609280 #33280MB (2^20)*33280
  low_memory_mapped_io_space    = 3221225472 #3GB (2^30)*3
  memory_startup_bytes          = 12884901888 #12288MB (2^33)+(2^32)
  memory_maximum_bytes          = 12884901888 #12288MB (2^33)+(2^32)
  # memory_minimum_bytes          = 268435456 #256MB 2^28
  memory_minimum_bytes          = 12884901888 #12288MB (2^33)+(2^32)
  wait_for_state_timeout        = 10
  wait_for_ips_timeout          = 10
  # state                         = "Off"
  state                         = "${var.state}"

  vm_firmware {
    # enable_secure_boot = "On"
    enable_secure_boot = "Off"
    secure_boot_template = "MicrosoftUEFICertificateAuthority"
    # boot_order {
    #   boot_type = "HardDiskDrive"
    #   controller_number     = 0
    #   controller_location   = 0
    # }
    # boot_order {
    #   boot_type = "HardDiskDrive"
    #   controller_number     = 0
    #   controller_location   = 1
    # }
    # boot_order {
    #   boot_type = "HardDiskDrive"
    #   controller_number     = 0
    #   controller_location   = 2
    # }
    # boot_order {
    #   boot_type = "DvdDrive"
    #   controller_number     = 0
    #   controller_location   = 3
    # }
    # boot_order {
    #   boot_type = "DvdDrive"
    #   controller_number     = 0
    #   controller_location   = 4
    # }
    # boot_order {
    #   boot_type             = "NetworkAdapter"
    #   network_adapter_name  = "k8s"
    # }
  }

  vm_processor {
    expose_virtualization_extensions = true
  }

  network_adaptors {
    # dynamic_mac_address= false
    name               = data.hyperv_network_switch.k8s_network_switch.name
    # static_mac_address = "00:00:10:00:00:04"
    switch_name        = data.hyperv_network_switch.k8s_network_switch.name
    wait_for_ips       = false
  }
  dvd_drives {
    controller_number   = 0
    controller_location = 3
    path                = "C:\\Users\\<user>\\Downloads\\ubuntu-22.04.1-live-server-amd64-autoinstall.iso"
    # path                = "C:\\Users\\<user>\\Downloads\\alpine-virt-3.16.2-x86_64.iso"
    resource_pool_name  = "Primordial"
  }

  dvd_drives {
    controller_number   = 0
    controller_location = 4
    path                = "C:\\Users\\<user>\\Downloads\\k8s-control-1-seed.iso"
    resource_pool_name  = "Primordial"
  }

  hard_disk_drives {
    controller_type     = "Scsi"
    path                = hyperv_vhd.k8s_control_1_vhd_0.path
    controller_number   = 0
    controller_location = 0
    resource_pool_name  = "Primordial"
  }

  hard_disk_drives {
    controller_type     = "Scsi"
    path                = hyperv_vhd.k8s_control_1_vhd_1.path
    controller_number   = 0
    controller_location = 1
    resource_pool_name  = "Primordial"
  }

  hard_disk_drives {
    controller_type     = "Scsi"
    path                = hyperv_vhd.k8s_control_1_vhd_2.path
    controller_number   = 0
    controller_location = 2
    resource_pool_name  = "Primordial"
  }
}

# Control Node 2
resource "hyperv_vhd" "k8s_control_2_vhd_0" {
  path = "C:\\K8sImages\\k8s(ubuntu)\\k8s-control-2\\k8s-control-2-disk-0.vhdx" #Needs to be absolute path
  size = 68719476736                                                            #64GB
  block_size = 1048576                                                           #1MB
}

resource "hyperv_vhd" "k8s_control_2_vhd_1" {
  path = "C:\\K8sImages\\k8s(ubuntu)\\k8s-control-2\\k8s-control-2-disk-1.vhdx" #Needs to be absolute path
  size = 10737418240                                                            #10GB
  block_size = 1048576                                                           #1MB
}

resource "hyperv_vhd" "k8s_control_2_vhd_2" {
  path = "C:\\K8sImages\\k8s(ubuntu)\\k8s-control-2\\k8s-control-2-disk-2.vhdx" #Needs to be absolute path
  size = 107374182400                                                            #100GB
  block_size = 1048576                                                           #1MB
}

resource "hyperv_machine_instance" "k8s_control_2" {
  name                          = "k8s-control-2"
  path                          = "C:\\K8sImages\\k8s(ubuntu)\\"
  # path                          = "C:\\K8sImages\\k8s(alpine)\\"
  generation                    = 2
  processor_count               = 6
  dynamic_memory                = true
  guest_controlled_cache_types  = true
  high_memory_mapped_io_space   = 34896609280 #33280MB (2^20)*33280
  low_memory_mapped_io_space    = 3221225472 #3GB (2^30)*3
  memory_startup_bytes          = 12884901888 #12288MB (2^33)+(2^32)
  memory_maximum_bytes          = 12884901888 #12288MB (2^33)+(2^32)
  # memory_minimum_bytes          = 268435456 #256MB 2^28
  memory_minimum_bytes          = 12884901888 #12288MB (2^33)+(2^32)
  wait_for_state_timeout        = 10
  wait_for_ips_timeout          = 10
  # state                         = "Off"
  state                         = "${var.state}"

  vm_firmware {
    # enable_secure_boot = "On"
    enable_secure_boot = "Off"
    secure_boot_template = "MicrosoftUEFICertificateAuthority"
    # boot_order {
    #   boot_type = "HardDiskDrive"
    #   controller_number     = 0
    #   controller_location   = 0
    # }
    # boot_order {
    #   boot_type = "HardDiskDrive"
    #   controller_number     = 0
    #   controller_location   = 1
    # }
    # boot_order {
    #   boot_type = "HardDiskDrive"
    #   controller_number     = 0
    #   controller_location   = 2
    # }
    # boot_order {
    #   boot_type = "DvdDrive"
    #   controller_number     = 0
    #   controller_location   = 3
    # }
    # boot_order {
    #   boot_type = "DvdDrive"
    #   controller_number     = 0
    #   controller_location   = 4
    # }
    # boot_order {
    #   boot_type             = "NetworkAdapter"
    #   network_adapter_name  = "k8s"
    # }
  }

  vm_processor {
    expose_virtualization_extensions = true
  }

  network_adaptors {
    # dynamic_mac_address= false
    name               = data.hyperv_network_switch.k8s_network_switch.name
    # static_mac_address = "00:00:10:00:00:05"
    switch_name        = data.hyperv_network_switch.k8s_network_switch.name
    wait_for_ips       = false
  }
  dvd_drives {
    controller_number   = 0
    controller_location = 3
    path                = "C:\\Users\\<user>\\Downloads\\ubuntu-22.04.1-live-server-amd64-autoinstall.iso"
    # path                = "C:\\Users\\<user>\\Downloads\\alpine-virt-3.16.2-x86_64.iso"
    resource_pool_name  = "Primordial"
  }

  dvd_drives {
    controller_number   = 0
    controller_location = 4
    path                = "C:\\Users\\<user>\\Downloads\\k8s-control-2-seed.iso"
    resource_pool_name  = "Primordial"
  }

  hard_disk_drives {
    controller_type     = "Scsi"
    path                = hyperv_vhd.k8s_control_2_vhd_0.path
    controller_number   = 0
    controller_location = 0
    resource_pool_name  = "Primordial"
  }

  hard_disk_drives {
    controller_type     = "Scsi"
    path                = hyperv_vhd.k8s_control_2_vhd_1.path
    controller_number   = 0
    controller_location = 1
    resource_pool_name  = "Primordial"
  }

  hard_disk_drives {
    controller_type     = "Scsi"
    path                = hyperv_vhd.k8s_control_2_vhd_2.path
    controller_number   = 0
    controller_location = 2
    resource_pool_name  = "Primordial"
  }
}