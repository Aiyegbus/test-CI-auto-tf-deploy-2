# Define the AWS provider
provider "aws" {
  region = "us-west-1" # Change this to your desired AWS region
}

# Create a VPC
resource "aws_vpc" "ij_vpc" {
  cidr_block = "172.16.0.0/16"
}

#Create a Subnet
resource "aws_subnet" "example_subnet" {
  vpc_id     = aws_vpc.ij_vpc.id
  cidr_block = "172.16.0.0/18"
}


# Create a security group
resource "aws_security_group" "example_sg" {
  name        = "example-sg"
  description = "Example security group"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.ij_vpc.id
}

# Create an EC2 instance
resource "aws_instance" "ayo_instance" {
  ami           = "ami-0f8e81a3da6e2510a" # Amazon Linux 2 AMI in us-west-1
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.example_subnet.id # You'll need to define a subnet
  key_name      = "ayoterraformkey"            # Change this to your key pair name

  tags = {
    Name = "ExampleInstance"
  }

  // vpc_security_group_id = aws_security_group.example_sg.id
}
