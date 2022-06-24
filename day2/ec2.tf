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

resource "aws_instance" "sathya-instance" {
  ami           = var.image
  instance_type = var.instance_type
  subnet_id = "subnet-0ca0da59336525821"
  security_groups = [ "ec2-sg" ]
  
  tags = {
    Name = "HelloSathya"
  }

  
}


