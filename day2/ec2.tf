variable "image" {
    default = "ami-077fb40eebcc23898"
  
}

variable "instance_type" {
    default = "t3.medium"
  
}

variable "region" {
    default = "us-east-1"
  
}
variable "access_key" {
  
}

variable "secret_key" {
  
}

provider "aws" {
  region = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

resource "aws_instance" "nithya-instance" {
  ami           = var.image
  instance_type = var.instance_type
  subnet_id = "subnet-05de610920e3877c0"
  security_groups = [ "sg-0d951db71f2889cce" ]
  
  tags = {
    Name = "HelloNithya"
  }
  
}
