terraform {
  required_providers {
    proxmox = {
      source  = "telmate/proxmox"
      version = "2.9.11"
    }
  }
}

resource "proxmox_vm_qemu" "vm1" {
  count       = var.vm_count
  name        = "${var.vm_name}${count.index}"
  target_node = var.target_node

  # Clone VM from template
  clone = "ubuntu22.04"

  # Other params
  memory = 2048
  cores  = 2
	agent  = 1

  # Test SSH login
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible all -m ping -u ${var.ansible_user} -i '${self.ssh_host},' -i ./inventory/hosts"
  }

  # Run Ansible scripts (main.yml)
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook main.yml -u ${var.ansible_user} -i '${self.ssh_host},' -i ./inventory/hosts --extra-vars \"new_hostname=${var.vm_name}${count.index}\" --extra-vars \"ansible_become_password=${var.ansible_password}\""
  }
}

output "vm_ip_addresses" {
  value = {
    for vm in proxmox_vm_qemu.vm1 :
    	vm.name => vm.ssh_host
  }
}
