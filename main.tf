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

#--------- Ubuntu ---------#

resource "local_sensitive_file" "hosts_file" {
  count = var.node_os == "ubuntu" ? 1 : 0
  content = templatefile("hosts.tpl", {
    ansible_user = var.ansible_user,
    ansible_password = var.ansible_password,
  })
  filename = "./inventory/hosts"
}

module "controllers_ubuntu" {
  count = var.node_os == "ubuntu" ? 1 : 0
  source = "./modules/ubuntu-pve"

  target_node = var.target_node
  ansible_user = var.ansible_user
  ansible_password = var.ansible_password

  vm_name = "TFcontroller"
  vm_count = 1
}

module "workers_ubuntu" {
  count = var.node_os == "ubuntu" ? 1 : 0
  source = "./modules/ubuntu-pve"

  target_node = var.target_node
  ansible_user = var.ansible_user
  ansible_password = var.ansible_password

  vm_name = "TFworker"
  vm_count = 2
}

#--------- Talos ---------#

module "controllers_talos" {
  count = var.node_os == "talos" ? 1 : 0
  source = "./modules/talos-pve"

  target_node = var.target_node
  ansible_user = var.ansible_user
  ansible_password = var.ansible_password

  vm_name = "TFcontroller"
  vm_count = 1
}

module "workers_talos" {
  count = var.node_os == "talos" ? 1 : 0
  source = "./modules/talos-pve"

  target_node = var.target_node
  ansible_user = var.ansible_user
  ansible_password = var.ansible_password

  vm_name = "TFworker"
  vm_count = 2
}

#--------- Output ---------#

output "controllers_ip_addresses" {
  value = var.node_os == "ubuntu" ? "${module.controllers_ubuntu[0].vm_ip_addresses}" : "${module.controllers_talos[0].vm_ip_addresses}"
}

output "workers_ip_addresses" {
  value = var.node_os == "ubuntu" ? "${module.workers_ubuntu[0].vm_ip_addresses}" : "${module.workers_talos[0].vm_ip_addresses}"
}
