variable "image" {
    default = "ami-068257025f72f470d"
}

variable "instance_type" {
    default = "t3.medium"
}

variable "subnet" {
    default = "subnet-a5f313ce"
}

variable "sg" {
    default = ["sg-b66b83cc"]
}

variable "region" {
    default = "ap-south-1"
}

variable "key_name" { 
    default = "ycs-key"
}

variable "private_key_path" { 
    default =  "~/.ssh/id_rsa"
}

provider "aws" {
  region     = var.region
  profile    = "default"
}

data "aws_ami" "centos" {
owners      = ["679593333241"]
most_recent = true

  filter {
      name   = "name"
      values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
      name   = "architecture"
      values = ["x86_64"]
  }
}

resource "aws_key_pair" "deployer" {
  key_name   = "ycs-key"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCyP5aUel1ZCowv34AgyiuLWZ++jwftP2EF+jAtOk5ESfm+Epj04/xs7Dyq+VMNOG8MBHtuv8/hCeDnzg5C7fQFsENL2GEACNXYpHdldgv/PJACsl1yaMZU/4GgqBFO+iujdDcR/ohlNqVaeMI26Xk/zeBz0m++oULrXtS6ZtidSCUjiYJb3thPvN25G7RxmSWnSqY8izChTnh+kX1YL5HRFA7NMyosImNcl0Ybzo9TkkcQK9Da6GKZn+WY1YBQJWfO3iIDPC2wqNDHEdRRcE3Jt+4DoFeQeE3L4Fxpg9weD/pRS46r9vsMHw4rRIyGfrsuXd8atvTa5Rret89VdD7/rl1ckWFYo226/yxAUZANa2cQkMok79RYmCcoEsFecA2U900sHqPZ+NifRzyPo1NkvF5+nQJ1QhT0Xy8sRC3dR8X5evPIr1R0xrEzmCiUsSx6CKrhZU8t9HVxsL+r0KbpepLnG3JGtI8GqtDwvXgrlYZasxJatrXwwBBIm0M19tgUKQp0ZUfzGQS2CwvRYqNzzoVl9Cb5da8Ac+XCYUGdTfRyucB5LwU5kvzKbv3y1NCL1+QLTy5WFehDv/dML2l5a9ABUVodA5evqn6v8lGkYmDS6a9Vj5AEcVKeTQPCvi2XyuR+NQUsdBG4vopVzauwgLaMnrYa9akDdTGh+BpGuQ== chandra@zelarsoft.com"
}

resource "aws_instance" "chandra" {
  ami           = var.image
  instance_type = var.instance_type
  subnet_id     = var.subnet
  security_groups = var.sg

  tags = {
    Name = "HiChandra"
  }

  connection {
    type     = "ssh"
    user     = "ubuntu"
    private_key = "${file(var.private_key_path)}"
    host     = self.public_ip
  }  

  provisioner "remote-exec" {
    inline = [
      "sudo yum update",
      "sudo yum install nginx -y"
    ]
  } 
}

resource "aws_eip" "lb" {
  instance = aws_instance.chandra.id
  vpc      = true
}