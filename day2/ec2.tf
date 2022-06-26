variable "image" {
    default = "ami-077fb40eebcc23898"
  
}

variable "instance_type" {
    default = "t2.micro"
  
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
# provider "aws" {
#   region     = "us-east-1"
#   access_key = "AKIATUS77UQN73TAMIMZ"
#   secret_key = "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"
#}

# variable "image" {
#     default = "ami-0cff7528ff583bf9a"
  
# }

# variable "instance_type" {
#     default = "t3.medium"
  
# }


resource "aws_instance" "my-demo" {
  ami           = var.image
  instance_type = var.instance_type
  subnet_id = "subnet-03c3a9a4992d0e810"
  security_groups = [ "sg-0d951db71f2889cce" ]
  
  tags = {
    Name = "terraform"
  }

}
  
