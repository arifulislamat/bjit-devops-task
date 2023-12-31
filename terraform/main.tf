#
# Copyright (c) 2023 Ariful Islam
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the "Software"), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in
# all copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
# THE SOFTWARE.
#
# Contact Information:
# Name: Ariful Islam
# Email: arifulislamat@gmail.com
# Website: arifulislamat.com
#

# Terraform Provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "ap-south-1"
}

# Define the VPC
resource "aws_vpc" "bjit_vpc" {
  cidr_block       = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "bjit-vpc"
    Project = "BJIT DevOps Task"
    Author = "Ariful Islam"
  }
}

# Define the subnets in three availability zones
variable "availability_zones" {
  default = ["ap-south-1a", "ap-south-1b", "ap-south-1c"]
}
# Define the subnets
resource "aws_subnet" "public_subnet" {
  count             = 3
  vpc_id            = aws_vpc.bjit_vpc.id
  cidr_block        = "10.0.${4 + count.index * 2}.0/24"
  availability_zone = element(var.availability_zones, count.index)
  map_public_ip_on_launch = true
  tags = {
    Name = "bjit-subnet-public-ap-south-${count.index + 1}"
    Project = "BJIT DevOps Task"
    Author = "Ariful Islam"
  }
}

resource "aws_subnet" "private_subnet" {
  count             = 3
  vpc_id            = aws_vpc.bjit_vpc.id
  cidr_block        = "10.0.${10 + count.index * 2}.0/24"
  availability_zone = element(var.availability_zones, count.index)
  tags = {
    Name = "bjit-subnet-private-ap-south-${count.index + 1}"
    Project = "BJIT DevOps Task"
    Author = "Ariful Islam"
  }
}

# Create VPC endpoints for S3
resource "aws_vpc_endpoint" "bjit_s3_endpoint" {
  vpc_id = aws_vpc.bjit_vpc.id
  service_name = "com.amazonaws.ap-south-1.s3"
  route_table_ids = [for rt in aws_route_table.private_route_table : rt.id]  
  tags = {
    Name = "bjit-s3-endpoint"
    Project = "BJIT DevOps Task"
    Author = "Ariful Islam" 
  }
}

# Define security groups
resource "aws_security_group" "bjit_alb_sg" {
  name = "bjit-api-server-ALB-SG"
  description = "Security group for ALB"
  vpc_id      = aws_vpc.bjit_vpc.id
  tags = {
    Name = "bjit-api-server-ALB"
    Project = "BJIT DevOps Task"
    Author = "Ariful Islam" 
  }
}

resource "aws_security_group_rule" "bjit_alb_http_https" {
  type             = "ingress"
  from_port        = 80
  to_port          = 443
  protocol         = "tcp"
  security_group_id = aws_security_group.bjit_alb_sg.id
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group" "bjit_rds_sg" {
  name = "bjit-mariaDB-RDS-SG"
  description = "Security group for MariaDB RDS"
  vpc_id      = aws_vpc.bjit_vpc.id
  tags = {
    Name = "bjit-mariaDB-RDS"
    Project = "BJIT DevOps Task"
    Author = "Ariful Islam" 
  }
}

resource "aws_security_group_rule" "bjit_rds_port" {
  type        = "ingress"
  from_port   = 3306
  to_port     = 3306
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = aws_security_group.bjit_rds_sg.id
}

resource "aws_security_group" "bjit_redis_sg" {
  name = "bjit-redis-SG"
  description = "Security group for Redis"
  vpc_id      = aws_vpc.bjit_vpc.id
  tags = {
    Name = "bjit-redis-EC"
    Project = "BJIT DevOps Task"
    Author = "Ariful Islam" 
  }
}

resource "aws_security_group_rule" "bjit_redis_port" {
  type        = "ingress"
  from_port   = 6379
  to_port     = 6379
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = aws_security_group.bjit_redis_sg.id
}

resource "aws_security_group" "bjit_api_server_sg" {
  name = "bjit-api-server-SG"
  description = "Security group for API Server"
  vpc_id      = aws_vpc.bjit_vpc.id
  tags = {
    Name = "bjit-api-server"
    Project = "BJIT DevOps Task"
    Author = "Ariful Islam" 
  }
}

resource "aws_security_group_rule" "bjit_api_server_ports" {
  type        = "ingress"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = aws_security_group.bjit_api_server_sg.id
}

resource "aws_security_group_rule" "bjit_api_server_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = aws_security_group.bjit_api_server_sg.id
}

resource "aws_security_group" "bjit_file_server_sg" {
  name = "bjit-file-server-SG"
  description = "Security group for File Server"
  vpc_id      = aws_vpc.bjit_vpc.id
  tags = {
    Name = "bjit-file-server"
    Project = "BJIT DevOps Task"
    Author = "Ariful Islam" 
  }
}

resource "aws_security_group_rule" "bjit_file_server_ports" {
  type        = "ingress"
  from_port   = 8081
  to_port     = 8081
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = aws_security_group.bjit_file_server_sg.id
}

resource "aws_security_group_rule" "bjit_file_server_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["10.0.0.0/16"]
  security_group_id = aws_security_group.bjit_file_server_sg.id
}

resource "aws_security_group" "bjit_public_ssh_sg" {
  name = "bjit-public-ssh-SG"
  description = "Security group for Public SSH Access"
  vpc_id      = aws_vpc.bjit_vpc.id
  tags = {
    Name = "bjit-public-ssh"
    Project = "BJIT DevOps Task"
    Author = "Ariful Islam" 
  }
}
resource "aws_security_group_rule" "bjit_public_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bjit_public_ssh_sg.id
}

# Create an Internet Gateway
resource "aws_internet_gateway" "bjit_igw" {
  vpc_id = aws_vpc.bjit_vpc.id
   tags = {
    Name = "bjit-igw"
    Project = "BJIT DevOps Task"
    Author = "Ariful Islam" 
  }
}

# Create a public route table
resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.bjit_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.bjit_igw.id
  }

  tags = {
    Name = "bjit-rtb-public"
    Project = "BJIT DevOps Task"
    Author = "Ariful Islam" 
  }
}

# Create private route tables for each availability zone
resource "aws_route_table" "private_route_table" {
  count  = 3
  vpc_id = aws_vpc.bjit_vpc.id

  tags = {
    Name = "bjit-rtb-private-${element(var.availability_zones, count.index)}"
    Project = "BJIT DevOps Task"
    Author = "Ariful Islam" 
  }
}

# Associate public subnet with the public route table
resource "aws_route_table_association" "public_association" {
  count          = 3
  subnet_id      = aws_subnet.public_subnet[count.index].id
  route_table_id = aws_route_table.public_route_table.id
}

# Associate private subnet with their respective private route tables
resource "aws_route_table_association" "private_association" {
  count          = 3
  subnet_id      = aws_subnet.private_subnet[count.index].id
  route_table_id = element(aws_route_table.private_route_table, count.index).id
}
# Add outbound rules to security groups to allow all traffic
resource "aws_security_group_rule" "bjit_alb_outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bjit_alb_sg.id
}

resource "aws_security_group_rule" "bjit_rds_outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bjit_rds_sg.id
}

resource "aws_security_group_rule" "bjit_redis_outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bjit_redis_sg.id
}

resource "aws_security_group_rule" "bjit_api_server_outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bjit_api_server_sg.id
}
resource "aws_security_group_rule" "bjit_file_server_outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bjit_file_server_sg.id
}
resource "aws_security_group_rule" "bjit_public_ssh_outbound" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = aws_security_group.bjit_public_ssh_sg.id
}