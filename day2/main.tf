variable "image" {
    default = "ami-098e42ae54c764c35"
  
}

variable "instance_type" {
    default = "t3.micro"
  
}

variable "region" {
    default = "us-west-2"
  
}

variable "access_key" {
  
}

variable "secret_key" {
  
}

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}


resource "aws_instance" "sandbox" {
  ami           = var.image
  instance_type = var.instance_type

  tags = {
    Name = "HelloWorld"
  }    
  
}