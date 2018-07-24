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
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.checkpoint_dmz.id}"
  vpc_security_group_ids = ["${aws_security_group.checkpoint_dmz.id}"]
  key_name               = "${var.DEPLOY_KEY}"
  availability_zone      = "${var.AVAILABILTY_ZONE}"

  //  user_data                   = "${data.template_cloudinit_config.ansible_init.rendered}"
  associate_public_ip_address = true

  tags {
    Name = "checkpoint_ansible_new"
  }
}
