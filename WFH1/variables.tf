variable "image" {
    default = "ami-052efd3df9dad4825"
  
}

variable "instance_type" {
    default = "t2.medium"
  
}

# variable "subnet" {
#     default = "subnet-ae88b0e3"
  
# }

variable "sg" {
    default = ["sg-08020451082b6e7a6"]
  
}

variable "region" {
    default = "us-east-1"
  
}


variable "access_key" {
  default = "AKIAVMOC7EVAEUEIGP6U"
}

variable "secret_key" {
  default = "LSU/tRzhF4pR5EOo8xsQcOr2PE1ddPhSiwITURTD"
}
