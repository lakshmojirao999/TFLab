variable "image" {
    default = "ami-052efd3df9dad4825"
  
}

variable "instance_type" {
    default = "t3.medium"
  
}

# variable "subnet" {
#     default = "subnet-ae88b0e3"
  
# }

variable "sg" {
    default = ["sg-37809036"]
  
}

variable "region" {
    default = "us-east-1"
  
}


# variable "access_key" {
#   default = ""
# }

# variable "secret_key" {
#   default = ""
# }

provider "aws" {
  region     = var.region
}


resource "aws_instance" "Terraform" {
  ami           = var.image
  instance_type = var.instance_type
  subnet_id     = "subnet-ae88b0e3"
  security_groups = var.sg

  tags = {
    Name = "Terraform"
  }    
  
}

resource "aws_eip" "lb" {
  instance = aws_instance.Terraform.id
  vpc      = true
}