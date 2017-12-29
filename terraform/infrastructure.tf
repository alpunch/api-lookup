variable "aws_access_key" {}
variable "aws_secret_key" {}
variable "aws_key_path" {}
variable "aws_key_name" {}

variable "aws_region" {
    description = "EC2 Region for the VPC"
    default = "eu-west-1"
}

variable "availability_zones" {
  default     = "eu-west-1a,eu-west-1b"
  description = "List of availability zones"
}

variable "vpc_cidr" {
    description = "CIDR for the whole VPC"
    default = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
    description = "CIDR for the Public Subnet"
    default = "10.0.0.0/24"
}

variable "private_subnet_cidr" {
    description = "CIDR for the Private Subnet"
    default = "10.0.10.0/24"
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
      command = "sleep 30; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key /home/$USER/.ssh/id_rsa -i '${aws_instance.node.public_ip},' ../ansible/playbook.yml"
  }
}