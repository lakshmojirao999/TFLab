###########################
#       variables         #
###########################

variable "access_key" { default ="" }
variable "secret_key" { default ="" }
variable "region" { default ="us-east-1" }
variable "instance_type" { default ="t3.medium" }
variable "assign_public_ip" { default ="true" }
variable "subnetId" {default = "subnet-0da08f706ace71d96"}
variable "key_name" { default = "terraform-key"}
variable "private_key_path" { default =  "~/.ssh/id_rsa"}
variable "security_group" {default = "sg-075d9f9a89617f250" }  
###########################
#       provider          #
###########################

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

###########################
#       Resource          #
###########################


data "aws_ami" "red_hat" {
  most_recent = true

  filter {
    name   = "name"
    values = ["RHEL_HA-8.5_HVM-20220127-x86_64-3-Hourly2-GP2 *"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["202242095650"]# Canonical
}


resource "aws_key_pair" "instance" {
  key_name   = "terraform-key"
  public_key =""
}

resource "aws_instance" "intro" {
  ami           = data.aws_ami.red_hat.id
  instance_type = var.instance_type
  associate_public_ip_address = var.assign_public_ip
  subnet_id = var.subnetId
  key_name = var.key_name
  security_groups = var.security_group
  #key_name  = aws_key_pair.deployer.key_name

  tags = {
    Name = "Hello earth"
  } 

  connection {
    type     = "ssh"
    user     = "red_hat"
    private_key = "${file(var.private_key_path)}"
    host     = self.public_ip
  }  

  provisioner "remote-exec" {
    inline = [
      "sudo yum update",
      "sudo yum install wget unzip httpd -y",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "sudo yum install nginx -y " ,
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"

    ]
  } 
  
}

#######################################
#          Outputs                    #
#######################################

output "instance_ip" {
    value = aws_instance.intro.public_ip
  
}