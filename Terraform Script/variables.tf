variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_name" {
  type    = string
  default = "project_vpc"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}


variable "public_subnet_cidr" {
  description = "CIDR block for public subnet"
  type        = string
  default     = "10.0.10.0/24"
}

variable "my_ip" {
  description = "my ip address"
  type        = string
  sensitive   = true
}
