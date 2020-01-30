module "infra" {
  userdata = var.userdata

  #################
  # Digital Ocean #
  #################
  #source  = "./do_infra"
  #token   = var.do_token
  #ssh_key = var.do_ssh_key

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
  #source = "./azure_infra"


  ##########
  # Google #
  ##########
  source     = "./gcp_infra"
  accessfile = var.gcp_accessfile
  project    = var.gcp_project
  region     = var.region
  zone       = var.zone
}
