module "infra" {
  userdatadir = var.userdatadir

  #################
  # Digital Ocean #
  #################

  #source = "./do_infra"

  ##########
  # Amazon #
  ##########

  source = "./aws_infra"

  #############
  # Microsoft #
  #############

  #source = "./azure_infra"

  ##########
  # Google #
  ##########

  #source = "./gcp_infra"

}
