## VPC ##
resource "aws_vpc" "checkpoint_2" {
  cidr_block = "10.40.40.0/24"

  tags {
    Name = "checkpoint_2"
  }
}

## Add route table ##
resource "aws_main_route_table_association" "checkpoint_route_table" {
  route_table_id = "${aws_route_table.checkpoint_route_table.id}"
  vpc_id         = "${aws_vpc.checkpoint_2.id}"
}

resource "aws_route_table" "checkpoint_route_table" {
  vpc_id = "${aws_vpc.checkpoint_2.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.checkpoint_gw.id}"
  }

  tags {
    Name = "Checkpoint_gw"
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
  vpc_id            = "${aws_vpc.checkpoint_2.id}"
  cidr_block        = "10.40.40.0/26"
  availability_zone = "${var.AVAILABILTY_ZONE}"

  tags {
    Name = "Checkpoint_dmz"
  }
}

## checkpoint internal ##
resource "aws_subnet" "checkpoint_internal" {
  vpc_id            = "${aws_vpc.checkpoint_2.id}"
  cidr_block        = "10.40.40.64/26"
  availability_zone = "${var.AVAILABILTY_ZONE}"

  tags {
    Name = "Checkpoint_internal"
  }
}

## internal route table association ##
resource "aws_route_table_association" "checkpoint_internal_route" {
  route_table_id = "${aws_route_table.checkpoint_internal_route_table.id}"
  subnet_id      = "${aws_subnet.checkpoint_internal.id}"
}

## internal route table ##
resource "aws_route_table" "checkpoint_internal_route_table" {
  vpc_id = "${aws_vpc.checkpoint_2.id}"

  route {
    cidr_block           = "0.0.0.0/0"
    instance_id          = "${aws_instance.checkpoint_gateway.id}"
    network_interface_id = "${aws_network_interface.checkpoint_gateway_internal.id}"
  }

  tags {
    Name = "checkpoint_internal_gw"
  }
}

## EIP ##
data "aws_eip" "checkpoint_proxy_ip" {
  public_ip = "${var.NAT_PUBLIC_IP}"
}
