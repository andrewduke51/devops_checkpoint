provider "aws" {
  region                  = "${var.default_region}"
  shared_credentials_file = "${var.path_to_cred}"
  profile                 = "${var.aws_profile}"
}