module "infra" {
  userdata      = var.userdata
  control_count = var.control_count
  node_prefix   = var.node_prefix

  #################
  # Digital Ocean #
  #################
  source  = "./do_infra"
  token   = var.do_token
  ssh_key = var.do_ssh_key

  ##########
  # Amazon #
  ##########
  #  source     = "./aws_infra"
  #  access_key = var.aws_access_key
  #  secret_key = var.aws_secret_key
  #  vpc_id     = var.aws_vpc_id
  #  subnet_id  = var.aws_subnet_id

  #############
  # Microsoft #
  #############
  #source          = "./azure_infra"
  #client_id       = var.azure_client_id
  #tenant_id       = var.azure_tenant_id
  #subscription_id = var.azure_subscription_id
  #client_secret   = var.azure_client_secret

  ##########
  # Google #
  ##########
  #source     = "./gcp_infra"
  #accessfile = var.gcp_accessfile
  #project    = var.gcp_project
  #region     = var.gcp_region
  #zone       = var.gcp_zone
}
