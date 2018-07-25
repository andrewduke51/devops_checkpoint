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
    values = ["Check Point CloudGuard IaaS BYOL R80.10-026.303-e926bdfe-4f7e-420d-9e3e-ceebf7edfcdd*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

## ssh public key

resource "aws_key_pair" "ssh_pub" {
  key_name   = "tmp-key"
  public_key = "${file("${var.SSH_PUB_KEY}")}"
}

## ansible_server cloud init ##

data "template_file" "ansible_server" {
  template = "${file("${path.module}/templates/ansible.sh.tpl")}"
}

data "template_cloudinit_config" "ansible_init" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "ansible.sh"
    content_type = "text/x-shellscript"
    content      = "${data.template_file.ansible_server.rendered}"
  }
}
