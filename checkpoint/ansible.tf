## web_server ##

//data "template_file" "web_server" {
//  template = "${file("${path.module}/templates/ansible.sh.tpl")}"
//}
//
//data "template_cloudinit_config" "ansible_init" {
//  gzip          = false
//  base64_encode = false
//
//  part {
//    filename     = "ansible.sh"
//    content_type = "text/x-shellscript"
//    content      = "${data.template_file.web_server.rendered}"
//  }
//}

resource "aws_instance" "ansible_server" {
  ami                         = "ami-06f5be6e"
  instance_type               = "m1.large"
  subnet_id                   = "${aws_subnet.checkpoint_dmz.id}"
  vpc_security_group_ids      = ["${aws_security_group.checkpoint_dmz.id}"]
  key_name                    = "${aws_key_pair.ssh_pub.key_name}"
  availability_zone           = "${var.AVAILABILTY_ZONE}"
  private_ip                  = "${var.ANSIBLE_PRIVATE_IP}"
  associate_public_ip_address = true

  //  user_data                   = "${data.template_cloudinit_config.ansible_init.rendered}"

  provisioner "remote-exec" {
    inline = ["sudo apt-get -y install python", "sudo apt-get -y autoremove"]

    connection {
      type        = "ssh"
      user        = "ubuntu"
      private_key = "${file(var.SSH_PRIVATE_KEY)}"
    }
  }
  provisioner "file" {
    source      = "${var.SSH_PRIVATE_KEY}"
    destination = "${var.PATH_TO_RM_SSH}"
  }
  provisioner "local-exec" {
    command = "sleep 120; ansible-playbook --ssh-common-args='-o StrictHostKeyChecking=no' -u ubuntu -i '${aws_instance.ansible_server.public_ip},' --private-key ${var.PATH_TO_PEM} ${var.PATH_TO_ANSIBLE_YAML}"
  }
  tags {
    Name = "checkpoint_ansible_new"
  }
}
