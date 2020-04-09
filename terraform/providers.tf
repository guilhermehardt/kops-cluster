provider "aws" {
  region  = "us-east-2"
  version = ">= 2.56.0"
}

data "aws_availability_zones" "available" {
  state = "available"
}