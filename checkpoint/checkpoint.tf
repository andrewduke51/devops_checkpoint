//# deployment of checkpoint manager and gateway
//
//data "aws_ami" "checkpoint_instance" {
//  most_recent = true
//
//  filter {
//    name   = "name"
//    values = ["Check Point CloudGuard IaaS BYOL R80.10-*"]
//  }
//
//  filter {
//    name   = "virtualization-type"
//    values = ["hvm"]
//  }
//}
//
//resource "aws_instance" "web" {
//  ami           = "${data.aws_ami.checkpoint_instance.id}"
//  instance_type = "m4.large"
//
//
//  tags {
//    Name = "checkpoint_manager_new"
//  }
//}