provider "aws" {
  version = ">= 2.17"
  region  = "eu-west-1"
}
module "machine_user" {
  source            = "../"
  ci_parameters_key = "test"
  name_prefix       = "test"
}
