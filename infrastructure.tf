# Global vars declaration
variable "region" {}

# Instance vars declaration


# Define instance
resource "aws_instance" "node" {
  ami           = "ami-8fd760f6"
  instance_type = "t2.micro"
  key_name      = "LT-APU-Ubuntu"
  tags          = "[Name=Node]"
}

# Assing elastic IP
resource "aws_eip" "ip" {
  instance = "${aws_instance.node.id}"
}