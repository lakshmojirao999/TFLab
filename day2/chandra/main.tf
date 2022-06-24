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

provider "aws" {
  region     = var.region
  profile    = "default"
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