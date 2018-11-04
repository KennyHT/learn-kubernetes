provider "aws" {
  shared_credentials_file = ".aws/credentials"
  region = "${var.region}"
}

# ------------------------------------------
# SECURITY GROUP
# ------------------------------------------

resource "aws_security_group" "this" {
  name        = "${var.name}-minikube"
  description = "Allow all inbound traffic to 22 and 8080"
  vpc_id      = "${var.vpc_id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.ingress_cidr}"]
  }

    ingress {
    from_port   = 8443
    to_port     = 8443
    protocol    = "tcp"
    cidr_blocks = ["${var.ingress_cidr}"]
  }

  ingress {
    from_port   = 30000
    to_port     = 32767
    protocol    = "tcp"
    cidr_blocks = ["${var.ingress_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "${var.name}-minikube"
  }
}

# ------------------------------------------
# AMI
# ------------------------------------------

data "aws_ami" "this" {
    most_recent = true

    filter {
        name   = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }

     # Canonical
    owners = ["099720109477"]
} 

# ------------------------------------------
# EC2 INSTANCE
# ------------------------------------------

resource "aws_instance" "this" {
  ami                    = "${data.aws_ami.this.id}"
  instance_type          = "${var.instance_type}"
  vpc_security_group_ids = ["${aws_security_group.this.id}"]
  subnet_id              = "${var.subnet_id}"
  key_name               = "${var.key_name}"

  user_data = "${file("resources/user-data.sh")}"

  tags {
    Name = "${var.name}-minikube"
  }
}
