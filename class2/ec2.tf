variable "image" {
    default = "ami-0cff7528ff583bf9a"

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
  region     = "us-east-1"
  access_key = "var.access_key"
  secret_key = "var.secret_key"
}


resource "aws_instance" "intro" {
  ami           = var.image
  instance_type = var.instance_type
  subnet_id     = "subnet-0405a9c8c1a899c4a"
  vpc_security_group_ids = ["sg-075d9f9a89617f250"]
     tags = {
    Name = "terraform"
  }    

} 

  
