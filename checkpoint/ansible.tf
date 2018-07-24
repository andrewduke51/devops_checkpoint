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
  ami                    = "ami-06f5be6e"
  instance_type          = "t1.micro"
  subnet_id              = "${aws_subnet.checkpoint_dmz.id}"
  vpc_security_group_ids = ["${aws_security_group.checkpoint_dmz.id}"]
  key_name               = "${var.DEPLOY_KEY}"
  availability_zone      = "${var.AVAILABILTY_ZONE}"

  //  user_data                   = "${data.template_cloudinit_config.ansible_init.rendered}"
  associate_public_ip_address = true

  # This is where we configure the instance with ansible-playbook
  provisioner "local-exec" {
    command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key ${var.PATH_TO_PEM} -i '${aws_instance.ansible_server.public_ip}, '../playbooks/roles/ansible/tasks/main.yml"
  }

  tags {
    Name = "checkpoint_ansible_new"
  }
}
