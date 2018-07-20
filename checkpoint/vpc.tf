## VPC ##
resource "aws_vpc" "checkpoint_2" {
  cidr_block       = "10.40.40.0/24"

  tags {
    Name = "checkpoint_2"
  }
}

## Internet gateway ##
resource "aws_internet_gateway" "checkpoint_gw" {
  vpc_id = "${aws_vpc.checkpoint_2.id}"

  tags {
    Name = "checkout_gw"
  }
}


## NAT Gateway ##
resource "aws_nat_gateway" "checkout_nat_gw" {
  allocation_id = "${data.aws_eip.checkpoint_proxy_ip.id}"
  subnet_id     = "${aws_subnet.checkpoint_dmz.id}"

  tags {
    Name = "checkout_nat_gw"
  }

  depends_on = ["aws_internet_gateway.checkpoint_gw"]
}

## checkpoint dmz ##
resource "aws_subnet" "checkpoint_dmz" {
  vpc_id     = "${aws_vpc.checkpoint_2.id}"
  cidr_block = "10.40.40.0/26"
  availability_zone = "${var.AVAILABILTY_ZONE}"

  tags {
    Name = "Checkpoint_dmz"
  }
}

## checkpoint internal ##
resource "aws_subnet" "checkpoint_internal" {
  vpc_id     = "${aws_vpc.checkpoint_2.id}"
  cidr_block = "10.40.40.64/26"
  availability_zone = "${var.AVAILABILTY_ZONE}"

  tags {
    Name = "Checkpoint_internal"
  }
}

## EIP ##
data "aws_eip" "checkpoint_proxy_ip" {
  public_ip = "${var.PUBLIC_IP}"
}