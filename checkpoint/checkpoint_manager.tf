## checkpoint_manager ##
resource "aws_instance" "checkpoint_manager" {
  ami                    = "${data.aws_ami.checkpoint_instance.id}"
  instance_type          = "m4.large"
  subnet_id              = "${aws_subnet.checkpoint_dmz.id}"
  private_ip             = "${var.MANAGER_PRIVATE_IP}"
  vpc_security_group_ids = ["${aws_security_group.checkpoint_dmz.id}"]
  key_name               = "${aws_key_pair.ssh_pub.key_name}"
  availability_zone      = "${var.AVAILABILTY_ZONE}"

  tags {
    Name     = "checkpoint_manager_new"
    downtime = "yes"
  }
}

## eth 0 and EIP DMZ
resource "aws_eip_association" "eip_association_checkpoint_manager" {
  instance_id = "${aws_instance.checkpoint_manager.id}"
  public_ip   = "${var.MANAGER_PUBLIC_IP}"
}
