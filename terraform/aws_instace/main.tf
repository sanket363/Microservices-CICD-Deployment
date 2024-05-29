# provider block defines the cloud provider and its configuration
provider "aws" {
  region  = "us-east-1"
  profile = "default"
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

variable "instance_count" {
  description = "Number of instances to deploy"
  default     = 2
}

# resource block defines the AWS resources to be created
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  # other VPC configurations...
}

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.my_vpc.id
}

resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"
  map_public_ip_on_launch = true
  # other subnet configurations...
}

resource "aws_route_table" "my_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }
}

resource "aws_route_table_association" "my_route_table_association" {
  subnet_id      = aws_subnet.my_subnet.id
  route_table_id = aws_route_table.my_route_table.id
}

resource "aws_security_group" "my_sg" {
  vpc_id      = aws_vpc.my_vpc.id # Ensure the security group is created in the same VPC
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

resource "aws_instance" "my_instance" {
  count              = var.instance_count
  ami                = var.ami
  instance_type      = var.instance_type
  subnet_id          = aws_subnet.my_subnet.id
  vpc_security_group_ids = [aws_security_group.my_sg.id] # Correctly reference the security group ID
  key_name           = "new-test" # Specify the key pair name without .pem extension

  # other instance configurations...
}

# output block allows you to define values to be displayed after apply
output "instance_ips" {
  value = [for instance in aws_instance.my_instance : instance.public_ip]
}
