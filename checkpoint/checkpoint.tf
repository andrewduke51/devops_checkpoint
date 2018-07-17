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


## checkpoint_gateway ##
resource "aws_instance" "checkpoint_gateway" {
  ami           = "${data.aws_ami.checkpoint_instance.id}"
  instance_type = "m4.large"
  subnet_id = "${aws_subnet.checkpoint_dmz.id}"
  private_ip = "${var.GW_PRIVATE_IP}"
  tags {
    Name = "checkpoint_gateway_new"
  }
}

## eth 0 and EIP DMZ
resource "aws_eip_association" "eip_association_checkpoint_gateway" {
  instance_id   = "${aws_instance.checkpoint_gateway.id}"
  allocation_id = "${aws_eip.checkpoint_gateway_eth0.id}"
  public_ip = "${var.PUBLIC_IP}"
}

resource "aws_eip" "checkpoint_gateway_eth0" {
  vpc = true
  associate_with_private_ip = "${var.GW_PRIVATE_IP}"
}

//## eth 1 internal
//resource "aws_network_interface" "checkpoint_gateway_internal" {
//  subnet_id       = "${aws_subnet.checkpoint_internal.id}"
//  private_ips     = ["10.40.40.77"]
//  security_groups = ["${aws_security_group.checkpoint_internal.id}"]
//
//  attachment {
//    instance     = "${aws_instance.checkpoint_gateway.id}"
//    device_index = 1
//  }
//}