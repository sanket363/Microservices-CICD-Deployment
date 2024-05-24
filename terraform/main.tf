# provider block defines the cloud provider and its configuration
provider "aws" {
  region = "us-east-1"
  profile = "dfault"
}

# variable block allows you to define variables for reusability
variable "instance_type" {
  description = "Type of EC2 instance"
  default     = "t2.medium"
}
variable "ami" {
  description = "Amazon Machine Image ID"
  default     = "ami-04b70fa74e45c3917"
}

# resource block defines the AWS resources to be created
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  # other VPC configurations...
}
#resource "aws_security_group" "my_security_group" {
#  vpc_id = aws_vpc.my_vpc.id
  # other security group configurations...
#}

resource "aws_instance" "my_instance" {
  ami           = var.ami
  instance_type = var.instance_type
  subnet_id     = aws_subnet.my_subnet.id
  #security_group = [aws_security_group.my_security_group.id]
  # other instance configurations...
}

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  # other subnet configurations...
}

resource "aws_security_group" "my_sg" {
  name        = "my-security-group"
  description = "Allow inbound SSH and HTTP traffic"
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# output block allows you to define values to be displayed after apply
output "instance_ip" {
  value = aws_instance.my_instance.public_ip
}