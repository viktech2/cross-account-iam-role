# Playground account containing users
provider "aws" {
  version = "~> 2.49"
  profile = "imerit-io-playground"
  region  = var.region_playground
}

# Prod account
provider "aws" {
  version = "~> 2.49"
  profile = "imerit-io-dev"
  region  = var.region_dev
  alias   = "dev"
}
