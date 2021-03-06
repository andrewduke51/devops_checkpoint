## ansible server ##
resource "aws_instance" "ansible_server" {
  ami                         = "ami-06f5be6e"
  instance_type               = "m1.small"
  subnet_id                   = "${aws_subnet.checkpoint_dmz.id}"
  vpc_security_group_ids      = ["${aws_security_group.checkpoint_dmz.id}"]
  key_name                    = "${aws_key_pair.ssh_pub.key_name}"
  availability_zone           = "${var.AVAILABILTY_ZONE}"
  private_ip                  = "${var.ANSIBLE_PRIVATE_IP}"
  associate_public_ip_address = true

  //user_data                   = "${data.template_cloudinit_config.ansible_init.rendered}"

  provisioner "file" {
    source      = "${var.SSH_PRIVATE_KEY}"
    destination = "${var.PATH_TO_RM_SSH}"

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.SSH_PRIVATE_KEY)}"
    }
  }
  provisioner "local-exec" {
    command = "sleep 10; ansible-playbook --ssh-common-args='-o StrictHostKeyChecking=no' -u ubuntu -i '${aws_instance.ansible_server.public_ip},' --private-key ${var.SSH_PRIVATE_KEY} ${var.PATH_TO_ANSIBLE_YAML}"
  }
  provisioner "remote-exec" {
    inline = ["sudo apt-get -y autoremove"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.SSH_PRIVATE_KEY)}"
    }
  }
  tags {
    Name     = "checkpoint_ansible_new"
    downtime = "${var.DOWNTIME_TAG}"
  }
}

## public IP ansible ##
resource "aws_eip_association" "eip_association_ansible" {
  instance_id = "${aws_instance.ansible_server.id}"
  public_ip   = "${var.ANSIBLE_PUBLIC_IP}"
}
