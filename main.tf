
provider "aws"{
 access_key  = "AKIAXALIW7AEAFLLL5R6"
 secret_key  = "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"
 region      = "us-east-1"
 }
resource "aws_vpc" "vpc"{
  cidr_block = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
}
resource "aws_internet_gateway" "igw" {
  vpc_id = "vpc-0dae33f1228c31ed7"
}
resource "aws_subnet" "subnet_public" {
  vpc_id = "vpc-0dae33f1228c31ed7"
  cidr_block = "10.1.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone = "us-east-1a"
}
resource "aws_route_table" "rtb_public" {
  vpc_id = "vpc-0dae33f1228c31ed7"
route {
      cidr_block = "0.0.0.0/0"
      gateway_id = "igw-0119f69c82f3322ed"
}
}
resource "aws_route_table_association" "rta_subnet_public" {
  subnet_id      = "subnet-036573f2ec947ea8f"
  route_table_id = "rtb-0a849112becd02473"
}
resource "aws_security_group" "sg_22" {
  name = "sg_22"
  vpc_id = "vpc-0dae33f1228c31ed7"
  ingress {
      from_port   = 22
      to_port     = 22
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
  resource "aws_key_pair" "ec2key" {
  key_name = "ec2key"
  
   public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQD3F6tyPEFEzV0LX3X8BsXdMsQz1x2cEikKDEY0aIj41qgxMCP/iteneqXSIFZBp5vizPvaoIR3Um9xK7PGoW8giupGn+EPuxIA4cDM4vzOqOkiMPhz5XK0whEjkVzTo4+S0puvDZuwIsdiW9mxhJc7tgBNL0cYlWSYVkz4G/fslNfRPW5mYAM49f4fhtxPb5ok4Q2Lg9dPKVHO/Bgeu5woMc7RY0p1ej6D4CKFE6lymSDJpW0YHX/wqE9+cfEauh7xZcG0q9t2ta6F6fmX0agvpFyZo8aFbXeUBr7osSCJNgvavWbM/06niWrOvYX2xwWdhXmXSrbX8ZbabVohBK41 msubash174@gmail.com"
  }
  resource "aws_instance" "testInstance" {
  ami           = "ami-01d025118d8e760db"
  instance_type = "t2.micro"
  subnet_id = "subnet-036573f2ec947ea8f"
  vpc_security_group_ids = ["sg-06e239215b7ea6391"]
  key_name = "ec2key"
  }
  resource "aws_s3_bucket" "terraform" {
  bucket = "subash123456"
  }
  resource "aws_s3_bucket_public_access_block" "example" {
  bucket = "subash123456"
  block_public_acls   = false
}
  resource "aws_s3_bucket_object" "object" {
  depends_on = [aws_s3_bucket.terraform]
  bucket = "subash123456"
  key    = "new_object_key"
  source = "C:/Users/Admin/Desktop/document/new1.txt"
  }