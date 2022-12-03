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
    name        = "VM1"
    target_node = var.target_node

    #iso        = "ISO file name"

    # Clone VM from template
    clone = "ubuntu22.04"

    # Other params
    memory = 2048
}