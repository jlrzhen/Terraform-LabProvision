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

resource "local_sensitive_file" "hosts_file" {
  content = templatefile("hosts.tpl", {
    ansible_user = var.ansible_user,
    ansible_password = var.ansible_password,
  })
  filename = "./inventory/hosts"
}

module "controllers" {
  source = "./modules/ubuntu-pve"

  target_node = var.target_node
  ansible_user = var.ansible_user
  ansible_password = var.ansible_password

  vm_name = "TFcontroller"
  vm_count = 1
}

module "workers" {
  source = "./modules/ubuntu-pve"

  target_node = var.target_node
  ansible_user = var.ansible_user
  ansible_password = var.ansible_password

  vm_name = "TFworker"
  vm_count = 2
}