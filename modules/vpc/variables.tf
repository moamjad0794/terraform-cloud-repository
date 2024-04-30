variable "vpc-cidr_block" {
  description = " VPC CIDR Block value"
  default = "25.0.0.0/16"
}

variable "public-subnet-cidr" {
  description = "public subnet cidr"
  default = "25.0.1.0/24"
}

variable "private-subnet-cidr" {
  description = "private subnet cidr"
  default = "25.0.3.0/24"
}