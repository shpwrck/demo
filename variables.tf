variable "control_count" {
  default     = 1
  description = "Control Plane Count"
}

variable "le_email" {
  default     = "notanemail@notadomain.com"
  description = "If Let's Encrypt is the chosen CA, then an email address is required"
}

variable "rancher_version" {
  default = "2.3.5"
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

#################
# Digital Ocean #
#################

variable "do_token" {
  description = "The token under which all resources will be provisioned."
}
variable "do_ssh_key" {
  description = "The unique identifier for an ssh key associated with the target account."
}

#######
# GCP #
#######

variable "gcp_accessfile" {
}
variable "gcp_zone" {
}
variable "gcp_project" {
}
variable "gcp_region" {
}

#######
# AWS #
#######

variable "aws_access_key" {
}
variable "aws_secret_key" {
}
variable "aws_vpc_id" {
}
variable "aws_subnet_id" {
}

#########
# AZURE #
#########

variable "azure_client_id" {
}
variable "azure_tenant_id" {
}
variable "azure_subscription_id" {
}
variable "azure_client_secret" {
}
