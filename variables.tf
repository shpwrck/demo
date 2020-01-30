variable "control_count" {
  default     = 3
  description = "Control Plane Count"
}

variable "le_email" {
  default     = "notanemail@notadomain.com"
  description = "If Let's Encrypt is the chosen CA, then an email address is required"
}

variable "rancher_version" {
  default = "2.3.4"
}

variable "cert_manager_version" {
  default = "v0.9.1"
}

variable "kube_config_location" {
  default = "./config.demo"
}

variable "userdata" {
  default = "files/userdata"
}

variable "do_token" {
  description = "The token under which all resources will be provisioned."
}

variable "do_ssh_key" {
  description = "The unique identifier for an ssh key associated with the target account."
}

variable "gcp_accessfile" {
  description = ""
}

variable "aws_access_key" {
  description = ""
}

variable "aws_secret_key" {
  description = ""
}

variable "aws_vpc_id" {
  description = ""
}

variable "aws_subnet_id" {
  description = ""
}

