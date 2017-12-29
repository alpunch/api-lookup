/*
  Allow http / https
*/

resource "aws_security_group" "allow_http" {
  name        = "allow_http"
  description = "Allow all http and https traffic"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  
  tags {
    Name = "allow_http"
  }
}

/*
  ssh (for temporary Ansible usage, not enabled by default)
*/

resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow all ssh traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.private_subnet_cidr}"]
  }

  tags {
    Name = "allow_ssh"
  }
}

/*
  Web Servers
*/

resource "aws_security_group" "web" {
    name = "vpc_web"
    description = "Allow incoming HTTP connections."

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = 443
        to_port = 443
        protocol = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        from_port = -1
        to_port = -1
        protocol = "icmp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress { # SQL Server
        from_port = 1433
        to_port = 1433
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr}"]
    }
    egress { # MySQL
        from_port = 3306
        to_port = 3306
        protocol = "tcp"
        cidr_blocks = ["${var.private_subnet_cidr}"]
    }

    vpc_id = "${aws_vpc.default.id}"

    tags {
        Name = "WebServerSG"
    }
}