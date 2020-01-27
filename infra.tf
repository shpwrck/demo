module "infra" {
  userdata = var.userdata

  #################
  # Digital Ocean #
  #################
  #source = "./do_infra"

  ##########
  # Amazon #
  ##########
  #source         = "./aws_infra"

  #############
  # Microsoft #
  #############
  #source = "./azure_infra"

  ##########
  # Google #
  ##########

  #source = "./gcp_infra"
}
