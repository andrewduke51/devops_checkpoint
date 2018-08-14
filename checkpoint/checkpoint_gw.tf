## checkpoint_gateway ##
resource "aws_instance" "checkpoint_gateway" {
  ami                    = "${data.aws_ami.checkpoint_instance.id}"
  instance_type          = "${var.CHECKPOINT_INSTANCE_TYPE}"
  availability_zone      = "${var.AVAILABILTY_ZONE}"
  subnet_id              = "${aws_subnet.checkpoint_dmz.id}"
  key_name               = "${aws_key_pair.ssh_pub.key_name}"
  vpc_security_group_ids = ["${aws_security_group.checkpoint_dmz.id}"]
  private_ip             = "${var.GW_PRIVATE_IP_ETH0}"
  source_dest_check      = false
  user_data              = "${data.template_cloudinit_config.checkpoint_gw_init.rendered}"

  tags {
    Name     = "checkpoint_gateway_new"
    downtime = "${var.DOWNTIME_TAG}"
  }
}

## eth 1 EIP association ##
resource "aws_eip_association" "eip_association_checkpoint_gateway" {
  instance_id = "${aws_instance.checkpoint_gateway.id}"
  public_ip   = "${var.GW_PUBLIC_IP}"
}

resource "aws_network_interface" "checkpoint_gateway_internal" {
  subnet_id         = "${aws_subnet.checkpoint_internal.id}"
  private_ips       = ["${var.GW_PRIVATE_IP_ETH1}"]
  source_dest_check = false
  security_groups   = ["${aws_security_group.checkpoint_internal.id}"]

  attachment {
    instance     = "${aws_instance.checkpoint_gateway.id}"
    device_index = 1
  }
}
