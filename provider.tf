# Configure the AWS Provider
provider "aws" {
  version = "2.7"
  region  = var.aws_region

  # An authentication method is required to your AWS subscription. For details:
  # https://www.terraform.io/docs/providers/aws/index.html
}