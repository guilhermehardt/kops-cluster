variable "project-name" {
  description = "Type the project name"
  default = "k8s-labs"
}

variable "ssh-source-ip" {
  description = "Your public IP"
  default = "XXX.XXX.XXX.XXX/32"
}

variable "main-domain" {
  description = "Your domain name"
  default = "k8slabs.tk"
}

variable "network-cidr" {
  default = "110"
}

variable "public-subnets" {
  type    = list
  default = ["10.110.0.0/20", "10.110.16.0/20", "10.110.32.0/20"]
}