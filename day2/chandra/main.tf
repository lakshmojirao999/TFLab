variable "image" {
    default = "ami-068257025f72f470d"
  
}

variable "instance_type" {
    default = "t3.medium"
  
}

# variable "subnet" {
#     default = "subnet-ae88b0e3"
  
# }

variable "sg" {
    default = ["sg-b66b83cc"]
  
}

variable "region" {
    default = "ap-south-1"
  
}


variable "access_key" {
  default = "AKIATHIV3VM3P2J23SXR"
}

variable "secret_key" {
  default = "qhib88bR0EZf1F588j4jEn/cfmraiMlTa0B51bNh"
}

provider "aws" {
  region     = var.region
}


resource "aws_instance" "chandra" {
  ami           = var.image
  instance_type = var.instance_type
  subnet_id     = "subnet-a5f313ce"
  security_groups = var.sg

  tags = {
    Name = "HelloChandra"
  }    
  
}

resource "aws_eip" "lb" {
  instance = aws_instance.chandra.id
  vpc      = true
}