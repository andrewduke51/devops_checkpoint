//# deployment of checkpoint manager and gateway
//
//data "aws_ami" "checkpoint_instance" {
//  most_recent = true
//
//  filter {
//    name   = "name"
//    values = ["ubuntu/images/hvm-ssd/ubuntu-trusty-14.04-amd64-server-*"]
//  }
//
//  filter {
//    name   = "virtualization-type"
//    values = ["hvm"]
//  }
//
//  owners = ["*"] # Canonical
//}
//
//resource "aws_instance" "web" {
//  ami           = "${data.aws_ami.ubuntu.id}"
//  instance_type = "t2.micro"
//
//  tags {
//    Name = "HelloWorld"
//  }
//}