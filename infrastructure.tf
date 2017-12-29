# Global vars declaration
variable "region" {}

# Instance vars declaration
variable "availability_zones" {
  default     = "eu-west-1a,eu-west-1b"
  description = "List of availability zones, use AWS CLI to find yours"
}

# Create NSGs
## http / https
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

## ssh (for temporary Ansible usage, not enabled by default)
resource "aws_security_group" "allow_ssh" {
  name        = "allow_ssh"
  description = "Allow all ssh traffic"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "allow_ssh"
  }
}

# Get latest AMI packer-linux-aws-docker-latest
data "aws_ami" "docker-node" {
  most_recent = true

  filter {
    name   = "name"
    values = ["packer-linux-aws-docker-latest"]
  }
}

# Create docker-node launch configuration
resource "aws_launch_configuration" "docker-node-lc" {
  image_id      = "${data.aws_ami.docker-node.id}"
  name_prefix   = "docker-node-lc-"
  instance_type = "t2.micro"

  lifecycle {
    create_before_destroy = true
  }
}

# Creating Swarm master asg
resource "aws_autoscaling_group" "docker-master-asg" {
  name                 = "swarm-master-asg"
  launch_configuration = "${aws_launch_configuration.docker-node-lc.name}"
  min_size             = 2
  max_size             = 5
  force_delete = true
  availability_zones = ["${split(",", var.availability_zones)}"]

  tag {
    key                 = "Name"
    value               = "docker-master-asg"
    propagate_at_launch = "true"
}
}

# Creating Swarm node asg
resource "aws_autoscaling_group" "docker-node-asg" {
  name                 = "swarm-node-asg"
  launch_configuration = "${aws_launch_configuration.docker-node-lc.name}"
  min_size             = 3
  max_size             = 12
  force_delete = true
  availability_zones = ["${split(",", var.availability_zones)}"]

  tag {
    key                 = "Name"
    value               = "docker-node-asg"
    propagate_at_launch = "true"
}
}

# Instance provisioning
resource "aws_instance" "node" {
  ami           = "${data.aws_ami.docker-node.id}"
  instance_type = "t2.micro"
  key_name      = "LT-APU-Ubuntu"
  associate_public_ip_address = true
  security_groups = ["default", "allow_http"]

  tags {
    Name = "docker-node"
  }
    
   # This is where we configure the instance with ansible-playbook
  provisioner "local-exec" {
      command = "sleep 30; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key /home/$USER/.ssh/id_rsa -i '${aws_instance.node.public_ip},' playbook.yml"
  }

}