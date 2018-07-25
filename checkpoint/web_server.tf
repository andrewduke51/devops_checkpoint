## web_server ##

data "template_file" "web_server" {
  template = "${file("${path.module}/templates/webserver.sh.tpl")}"
}

data "template_cloudinit_config" "webserver_init" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "webserver.sh"
    content_type = "text/x-shellscript"
    content      = "${data.template_file.web_server.rendered}"
  }
}

resource "aws_instance" "web_server" {
  ami                    = "ami-b70554c8"
  instance_type          = "t2.micro"
  subnet_id              = "${aws_subnet.checkpoint_internal.id}"
  vpc_security_group_ids = ["${aws_security_group.checkpoint_internal.id}"]
  key_name               = "${aws_key_pair.ssh_pub.key_name}"
  availability_zone      = "${var.AVAILABILTY_ZONE}"
  user_data              = "${data.template_cloudinit_config.webserver_init.rendered}"

  //associate_public_ip_address = true

  tags {
    Name = "checkpoint_webserver_new"
  }
}
