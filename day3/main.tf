###########################
#       variables         #
###########################

variable "access_key" { default ="" }
variable "secret_key" { default ="" }
variable "region" { default ="us-west-2" }
variable "instance_type" { default ="t3.medium" }
variable "assign_public_ip" { default ="true" }
variable "subnetId" {default = "subnet-9681b3cc"}
variable "key_name" { default = "deployer-key"}
variable "private_key_path" { default =  "~/.ssh/id_rsa"}

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


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}


resource "aws_key_pair" "deployer" {
  key_name   = "deployer-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDANmeK+hHNaYUU105614+mmGyVi3R3e48XzdKqaNGk58dF9+zE2RL4hQNX26wggTru5WXKPDOiIXhu/QG4nxihXy8r8AjCVYUY5CRr84tuW/Zj4OKUBIC2khQZdHPt43T+7S2xBseLqgm3ZbzlwmQXvAkbMM4hfYkk0aZ6wI6+8ZbMsMtRGirGmaK3w8TtCZ68fAWpmkipLzHObXwYFdoS3ghie//bUGh6jXRBj20ct8HarJs8wiKe0i8JJD9YS3daV/k+noJ2858vUVnQkRV+6oE4fDB+2m6epZB9EtP637p+1bum/9qhhGQzx/VOaASer4o79vNqrQj9G3obYBYnzRZtBWWre8WgxbgHgSxlHMzNw56v/eIlzvuOxSjcHMzv//OlXkOlIyOVq0eKBl0GyD3lclH01ea7Xbz7kGnZWVPaNjaluqOWbg00J48MniH8ZmAd/VxblL0UbH0j3ayQxKOdgPSaJqgZOrG8VtcbAmI6sKThn5lRiDVsq12H2bUsa2hBJaupqnF8zu1wlv//n1QJnmjQr5AgYKz7W+Jx5a4tDN9v5UKDQHOkU/IAWFnaNaNIb0qd37nGBV7xGs25PkOU1OhmtpWanAX0CphWN286OnbVTkCf5bTAyR8hp9wDp2ImySd6jC9qGSDleoMnn77wL0+gyW+zN0oOBl7OaQ== lakshmoji@trysapling.com"
}

resource "aws_instance" "sandbox" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  associate_public_ip_address = var.assign_public_ip
  subnet_id = var.subnetId
  key_name = var.key_name
  #key_name  = aws_key_pair.deployer.key_name

  tags = {
    Name = "HelloWorld"
  } 

  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = "${file(var.private_key_path)}"
    host     = self.public_ip
  }  

  provisioner "remote-exec" {
    inline = [
      "sudo apt update",
      "sudo apt install nginx -y "
    ]
  } 
  
}

#######################################
#          Outputs                    #
#######################################

output "instance_ip" {
    value = aws_instance.sandbox.public_ip
  
}