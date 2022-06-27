###########################
#       variables         #
###########################

variable "access_key" { default ="" }
variable "secret_key" { default ="" }
variable "region" { default ="us-east-1" }
variable "instance_type" { default ="t2.micro" }
variable "assign_public_ip" { default ="true" }
variable "subnetId" {default = "subnet-0ca0da59336525821"}
variable "key_name" { default = "instance-key"}
variable "private_key_path" { default =  "~/.ssh/id_rsa"}
variable "security_group" { default = "sg-0caabe23d91edbf64" }

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


data "aws_ami" "amzn2" {
  most_recent = true

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel-5.10-hvm-2.0.20220606.1-x86_64-gp2"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  # owners = ["099720109477"] # Canonical
}


resource "aws_key_pair" "deployer" {
  key_name   = "instance-key"
  public_key = "<public-key>"
}

resource "aws_instance" "terraform-instance" {
  ami           = data.aws_ami.amzn2.id
  instance_type = var.instance_type
  associate_public_ip_address = var.assign_public_ip
  subnet_id = var.subnetId
  key_name = var.key_name
  security_group = var.security_group

  #key_name  = aws_key_pair.deployer.key_name

  tags = {
    Name = "Hello-ujji"
  } 

  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file(var.private_key_path)}"
    host     = self.public_ip
  }  

  provisioner "remote-exec" {
    inline = [
      "sudo yum update -y",
      "sudo yum install -y httpd"
      "sudo systemctl start httpd"
      "sudo systemctl enable httpd"
    ]
  } 
  
}

#######################################
#          Outputs                    #
#######################################

output "instance_ip" {
    value = aws_instance.terraform-instance.public_ip
  
}