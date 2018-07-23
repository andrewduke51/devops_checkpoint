# create dmz security group

resource "aws_security_group" "checkpoint_dmz" {
  name        = "checkpoint_dmz"
  description = "Allow some inbound traffic"
  vpc_id      = "${aws_vpc.checkpoint_2.id}"

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${split(",", var.ORIGIN_IPS)}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "checkpoint_dmz"
  }
}

# create internal security group

resource "aws_security_group" "checkpoint_internal" {
  name        = "checkpoint_internal"
  description = "allow dmz inbound traffic"
  vpc_id      = "${aws_vpc.checkpoint_2.id}"

  ingress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    security_groups = ["${aws_security_group.checkpoint_dmz.id}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "checkpoint_internal"
  }
}
