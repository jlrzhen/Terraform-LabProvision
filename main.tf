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

resource "proxmox_vm_qemu" "vm1" {
  count       = 1
  name        = "VM${count.index}"
  target_node = var.target_node

  # Clone VM from template
  clone = "ubuntu22.04"

  # Other params
  memory = 2048
  cores  = 2
	agent  = 1

	# Test SSH login
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible all -m ping -u root -i '${self.ssh_host},' -i ./inventory/hosts"
	}

  # Run Ansible scripts (main.yml)
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook main.yml -u root -i '${self.ssh_host},' -i ./inventory/hosts --extra-vars \"new_hostname=VM${count.index}\" --extra-vars \"ansible_become_password=${var.ansible_password}\""
	}
}

output "vm_ip_addresses" {
  value = {
    for vm in proxmox_vm_qemu.vm1 :
    	vm.name => vm.ssh_host
  }
}
