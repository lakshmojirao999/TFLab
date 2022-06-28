###########################
#       variables         #
###########################

variable "access_key" { default ="" }
variable "secret_key" { default ="" }
variable "region" { default ="us-east-1" }
variable "instance_type" { default ="t3.medium" }
variable "assign_public_ip" { default ="true" }
variable "subnetId" {default = "subnet-08hdc3a9a4992d0e8djd0"}
variable "key_name" { default = "instance-key"}
variable "private_key_path" { default =  "~/.ssh/id_rsa"}
variable "security_group" {default = "sg-54rf1db71sug449cce" }  

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


data "aws_ami" "centos" {
  most_recent = true

  filter {
    name   = "centos"
    values = ["CentOS Stream 9 x86_64 *"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["125523088429"] # Canonical
}


resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = ""
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  associate_public_ip_address = var.assign_public_ip
  subnet_id = var.subnetId
  key_name = var.key_name
  security_groups = var.security_group

  tags = {
    Name = "tf-instance"
  } 

  connection {
    type     = "ssh"
    user     = "centos"
    private_key = "${file(var.private_key_path)}"
    host     = self.public_ip
  }  

  provisioner "remote-exec" {
    inline = [
      "sudo yum update",
      "sudo yum install nginx -y ",
      "sudo systemctl start nginx",
      "sudo systemctl enable nginx"
      "sudo systemctl status nginx"
    ]
  } 
  
}

#######################################
#          Outputs                    #
#######################################

output "instance_ip" {
    value = aws_instance.ec2.public_ip
  

