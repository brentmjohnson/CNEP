variable "state" { default = "Running" }

terraform {
  required_version = ">= 1.3.7"
  required_providers {
    hyperv = {
      source = "taliesins/hyperv"
      # source  = "local/taliesins/hyperv"
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

# Control Node 0
resource "hyperv_vhd" "GPUPV2_vhd_0" {
  path = "C:\\K8sImages\\k8s(ubuntu)\\GPUPV2\\GPUPV2-disk-0.vhdx" #Needs to be absolute path
  size = 21474836480                                                            #20GB
  block_size = 1048576                                                           #1MB
}

resource "hyperv_machine_instance" "GPUPV2" {
  name                   = "GPUPV2"
  path                   = "C:\\K8sImages\\k8s(ubuntu)\\"
  generation             = 2
  processor_count        = 4
  dynamic_memory         = true
  memory_startup_bytes   = 4294967296 #4096MB (2^32)
  memory_maximum_bytes   = 4294967296 #4096MB (2^32)
  memory_minimum_bytes   = 268435456 #256MB 2^28
  wait_for_state_timeout = 10
  wait_for_ips_timeout   = 10
  # state                  = "Off"
  state                  = "${var.state}"

  vm_firmware {
    enable_secure_boot = "On"
    # enable_secure_boot = "Off"
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
    path                = "C:\\Users\\<user>\\Downloads\\GPUPV2-seed.iso"
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
  name                   = "k8s-control-1"
  path                   = "C:\\K8sImages\\k8s(ubuntu)\\"
  # path                   = "C:\\K8sImages\\k8s(alpine)\\"
  generation             = 2
  processor_count        = 6
  dynamic_memory         = true
  memory_startup_bytes   = 12884901888 #12288MB (2^33)+(2^32)
  memory_maximum_bytes   = 12884901888 #12288MB (2^33)+(2^32)
  memory_minimum_bytes   = 268435456 #256MB 2^28
  wait_for_state_timeout = 10
  wait_for_ips_timeout   = 10
  # state                  = "Off"
  state                  = "${var.state}"

  vm_firmware {
    enable_secure_boot = "On"
    # enable_secure_boot = "Off"
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
  name                   = "k8s-control-2"
  path                   = "C:\\K8sImages\\k8s(ubuntu)\\"
  # path                   = "C:\\K8sImages\\k8s(alpine)\\"
  generation             = 2
  processor_count        = 6
  dynamic_memory         = true
  memory_startup_bytes   = 12884901888 #12288MB (2^33)+(2^32)
  memory_maximum_bytes   = 12884901888 #12288MB (2^33)+(2^32)
  memory_minimum_bytes   = 268435456 #256MB 2^28
  wait_for_state_timeout = 10
  wait_for_ips_timeout   = 10
  # state                  = "Off"
  state                  = "${var.state}"

  vm_firmware {
    enable_secure_boot = "On"
    # enable_secure_boot = "Off"
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