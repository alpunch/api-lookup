# Define instance
resource "aws_instance" "example" {
  ami           = "ami-2757f631"
  instance_type = "t2.micro"
}

# Assing elastic IP
resource "aws_eip" "ip" {
  instance = "${aws_instance.example.id}"
}