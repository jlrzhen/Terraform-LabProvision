variable "pm_api_url" {
  type = string
}

variable "target_node" {
  type = string
}

variable "ansible_user" {
  type = string
  sensitive=true
}

variable "ansible_password" {
  type = string
  sensitive=true
}