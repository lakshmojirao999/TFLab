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
  access_key = "WRUATUS65UQN73TATEK"
  secret_key = "IOfncd72Pbb6sGLwL5Vm9BNMYb3Xeyh055nTbh"
}

variable "image" {
    default = "ami-0cff7528ff583bf8b"
  
}

variable "instance_type" {
    default = "t3.medium"
  
}


resource "aws_instance" "tf-instance" {
  ami           = var.image
  instance_type = var.instance_type
  subnet_id = "subnet-0fe50afdfec21e31d"
  security_groups = [ "sg-0565a9107b603a440" ]
  
  tags = {
    Name = "tf-instance"
  }

  
}