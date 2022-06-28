###########################
#       variables         #
###########################

variable "access_key" { default ="" }
variable "secret_key" { default ="" }
variable "region" { default ="us-east-1" }
variable "instance_type" { default ="t3.medium" }
variable "assign_public_ip" { default ="true" }
variable "subnetId" {default = "subnet-04ac392c03bd9301e"}
variable "key_name" { default = "instence-key"}
variable "private_key_path" { default =  "~/.ssh/id_rsa"}
variable "security_group" {default = "sg-0d24236f698e7f163" }  

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
    name   = "name"
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
  ami           = data.aws_ami.centos.id
  instance_type = var.instance_type
  associate_public_ip_address = var.assign_public_ip
  subnet_id = var.subnetId
  key_name = var.key_name
  security_groups = var.security_group
  #key_name  = aws_key_pair.deployer.key_name

  tags = {
    Name = "hello"
  } 

  connection {
    type     = "ssh"
    user     = "centos"
    private_key = "${file(var.private_key_path)}"
    host     = self.public_ip
  }  

  provisioner "remote-exec" {
    inline = [
      "sudo yum update httpd",
      "sudo yum install httpd ",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd"
    ]
  } 
  
}

#######################################
#          Outputs                    #
#######################################

output "instance_ip" {
    value = aws_instance.ec2.public_ip 
}