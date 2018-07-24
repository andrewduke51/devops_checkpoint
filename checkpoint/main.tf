provider "aws" {
  region                  = "${var.DEFAULT_REGION}"
  shared_credentials_file = "${var.PATH_TO_CRED}"
  profile                 = "${var.AWS_PROFILE}"
}

# deployment of checkpoint manager and gateway

data "aws_ami" "checkpoint_instance" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Check Point CloudGuard IaaS BYOL R80.10-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
