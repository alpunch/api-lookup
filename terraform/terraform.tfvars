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
    default = "10.10.0.0/24"
}