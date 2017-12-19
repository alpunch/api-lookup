# Global vars declaration
variable "region" {}

# Instance vars declaration


# Instance provisioning
resource "aws_instance" "node" {
  ami           = "ami-8fd760f6"
  instance_type = "t2.micro"
  key_name      = "LT-APU-Ubuntu"
  associate_public_ip_address = true

  tags {
    Name = "dev-node"
  }
    
    # This is where we configure the instance with ansible-playbook
    provisioner "local-exec" {
        command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u ubuntu --private-key /home/$USER/.ssh/id-rsa.pub -i '${aws_instance.node.public_ip},' playbook.yml"
    }

}

# Assing elastic IP
#resource "aws_eip" "ip" { 
#  instance = "${aws_instance.node.id}"
#}