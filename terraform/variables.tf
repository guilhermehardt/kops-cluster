variable "project-name" {
  default = "k8s-labs"
}

variable "network-cidr" {
  default = "110"
}

variable "public-subnets" {
  type    = list
  default = ["10.110.0.0/20", "10.110.16.0/20", "10.110.32.0/20"]
}

variable "ssh-source-ip" {
  default = "181.221.4.18/32"
}

variable "main-domain" {
  default = "k8slabs.tk"
}

