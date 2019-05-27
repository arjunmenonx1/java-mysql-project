provider "aws" {
  region = "ap-south-1"
  shared_credentials_file = "/var/lib/jenkins/.aws/credentials"
}


data "aws_vpc" "main" {
  tags = {
    name = "default"
  }
}


data "aws_subnet_ids" "all" {
  vpc_id = "${data.aws_vpc.main.id}"
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_instance" "tomcat" {
  ami             = "${data.aws_ami.ubuntu.id}"
  instance_type   = "t2.micro"
  count           = "1"
  security_groups = ["${aws_security_group.tomcat.id}"]
  key_name        = "master"
  subnet_id       = "${element(data.aws_subnet_ids.all.ids, count.index)}"

  tags = {
    Name = "tomcat"
  }
  
  connection {
    user        = "ubuntu"
    type        = "ssh"
    private_key = "${file("/var/lib/jenkins/master.pem")}"
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
	  "sudo apt-get install tomcat8 -y"
    ]
}
}

resource "aws_security_group" "tomcat" {
  name        = "tomcat"
  description = "Allow traffic for tomcat"
  vpc_id      = "${data.aws_vpc.main.id}"

  ingress {
  //this opens all ports. just for testing
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }
}

output "server_ip" {
value = "${aws_instance.tomcat.public_ip}"
}
