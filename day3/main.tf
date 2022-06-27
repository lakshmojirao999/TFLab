###########################
#       variables         #
###########################

variable "access_key" { default ="" }
variable "secret_key" { default ="" }
variable "region" { default ="us-east-1" }
variable "instance_type" { default ="t3.medium" }
variable "assign_public_ip" { default ="true" }
variable "subnetId" {default = "subnet-0fe50afdfec21e31d"}
variable "key_name" { default = "my-key"}
variable "private_key_path" { default =  "~/.ssh/id_rsa"}
variable "security_groups" {default= "sg-0caabe23d91edbf64"}

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


data "aws_ami" "windows" {
  most_recent = true

  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-2022.06.15]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["801119661308"] # Canonical
}


resource "aws_key_pair" "deployer" {
  key_name   = var.key_name
  public_key = ""
}

resource "aws_instance" "ec2" {
  ami           = data.aws_ami.windows.id
  instance_type = var.instance_type
  associate_public_ip_address = var.assign_public_ip
  subnet_id = var.subnetId
  key_name = var.key_name
  security_groups = [ var.security_groups ]
  #key_name  = aws_key_pair.deployer.key_name

  tags = {
    Name = "Hello Sathya"
  } 

  connection {
    type     = "ssh"
    user     = "windows"
    private_key = "${file(var.private_key_path)}"
    host     = self.public_ip
  }  

  provisioner "remote-exec" {
    inline = [
      "curl -l https://dlcdn.apache.org/httpd/httpd-2.4.54.tar.bz2",
      "unzip httpd-2.4.54.tar.bz2"
      "cp Apache24 c:\ "
      "cd C:\Apache24\bin "
      ",/httpd.exe"
    ]
  } 
}

#######################################
#          Outputs                    #
#######################################

output "instance_ip" {
    value = aws_instance.sandbox.public_ip
  
}