variable "region" {
  default = "us-east-2"
}
variable "environment" {
  default = "Development"
}
variable "vpc_id" {
  description = "VPC id"
  default = "vpc-00c8c64526530ab37"
}

variable "subnet_id" {
  description = "The subnet where the Jenkins EC2 instance will be launched"
  type        = string
  default     = "subnet-079ca8e9d55a2e037"
}


