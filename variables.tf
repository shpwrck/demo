variable "control_count" {
  default     = 3
  description = "Control Plane Count"
}

variable "location" {
  default = "East US"
}

variable "le_email" {
  default = "notanemail@notadomain.com"
}

variable "rancher_version" {
  default = "2.3.4"
}

variable "cert_manager_version" {
  default = "v0.9.1"
}

variable "userdata" {
  default = "files/userdata"
}
