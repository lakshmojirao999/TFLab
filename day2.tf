variable "image" {
    default = "ami-0cff7528ff583bf9a"
  
}

variable "access_key" {
  
}

variable "secret_key" {
  
}

variable "instance_type" {
    default = "t3.medium"
  
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "4.19.0"
    }
  }
}

provider "aws" {
  region     = "us-east-1"
  access_key = "var.access_key"
  secret_key = "var.secret_key"
}



resource "aws_instance" "my-demo" {
  ami           = var.image
  instance_type = var.instance_type
  subnet_id = "subnet-047fbdde8cc106062"
  security_groups = [ "sg-0777a9107c603a704" ]
  
  tags = {
    Name = "terraform"
  }

  
}










