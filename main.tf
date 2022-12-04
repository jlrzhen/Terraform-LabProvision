terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.11"
    }
  }
}

provider "proxmox" {
  # Configuration options
  pm_api_url = var.pm_api_url
}

resource "proxmox_vm_qemu" "vm1" {
  count       = 2
  name        = "VM${count.index}"
  target_node = var.target_node

  # Clone VM from template
  clone = "ubuntu22.04"

  # Other params
  memory = 2048
  cores  = 2
	agent  = 1
}

output "vm_ip_addresses" {
  value = {
    for vm in proxmox_vm_qemu.vm1 :
    	vm.name => vm.ssh_host
  }
}
