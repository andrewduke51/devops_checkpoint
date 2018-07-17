provider "aws" {
  region                  = "${var.DEFAULT_REGION}"
  shared_credentials_file = "${var.PATH_TO_CRED}"
  profile                 = "${var.AWS_PROFILE}"
}