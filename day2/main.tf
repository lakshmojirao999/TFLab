provider "aws" {

}
variable "region" {
    default = "us-east-1"
}
variable "access_key" {
}
variable "secret_key" {
}

variable "image" {
    default = "ami-0cff7528ff583bf9a"
  
}

variable "instance_type" {
    default = "t3.medium"
  
}


resource "aws_instance" "tf-instate" {
  ami           = var.image
  instance_type = var.instance_type
  subnet_id = "subnet-04ac392c03bd9301e"
  security_groups = [ "sg-0d24236f698e7f163" ]

}
