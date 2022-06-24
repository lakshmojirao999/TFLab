provider "aws" {
  region     = var.region
}


resource "aws_instance" "terraform" {
  ami           = var.image
  instance_type = var.instance_type
  subnet_id     = "subnet-006db361f6070fe6f"
  security_groups = var.sg

  tags = {
    Name = "HomeWork"
  }    
  
}

resource "aws_eip" "lb" {
  instance = aws_instance.terraform.id
  vpc      = true
}