#VARIABLES
variable "access_key" { }
variable "secret_key" { }
variable "region" { default ="us-east-1" }
variable "instance_type" { default ="t3.medium" }
variable "assign_public_ip" { default ="true" }
variable "subnetId" {default = "subnet-047fbdde8cc106062"}
variable "key_name" { default = "ganesh.pem"}
variable "private_key_path" { default =  "~/.ssh/id_rsa"}
variable "security_groups" {default= "sg-08bced9332b7b96f9"}

#PROVIDER

provider "aws" {
  region     = var.region
  access_key = var.access_key
  secret_key = var.secret_key
}

#DATA


data "aws_ami" "Amazon_linux" {
  most_recent = true
  

  filter {
    name   = "name"
    values = ["Amazon Linux 2 Kernel 5.10 AMI 2.0.20220606"]
  }
  

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
        name   = "architecture"
        values = ["64-bit(x86)"]
    }
  owners = ["250383148059"] # Canonical
}



resource "aws_key_pair" "demo-key" {
  key_name   = var.key_name
  public_key = ""
}
resource "aws_instance" "demo" {
  ami           = data.aws_ami.Amazon_linux.id
  instance_type = var.instance_type
  associate_public_ip_address = var.assign_public_ip
  subnet_id = var.subnetId
  key_name = var.key_name
  security_groups = [ var.security_groups ]

  tags = {
    Name = "demo"
  } 
  connection {
    type     = "ssh"
    user     = "ec2-user"
    private_key = "${file(var.private_key_path)}"
    host     = self.public_ip
  }  
  provisioner "remote-exec" {
    inline = [
       "sudo yum update",
       "sudo yum install -y nginx",
       "sudo systemctl enable nginx",
       "sudo systemctl start nginx"   

      ]
  } 
}

#output
output "instance_ip" {
    value = aws_instance.demo.public_ip 
}

