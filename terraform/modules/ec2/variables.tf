variable "name" {
  description = "Name to be used on EC2 instance created."
  type        = string
  nullable    = false
}

variable "ami" {
  description = "ID of AMI to use for the instance."
  type        = string
  nullable    = false
}

variable "instance_type" {
  description = "The type of instance to start."
  type        = string
  default     = "t3.micro"
  nullable    = false
}

variable "vpc_security_group_ids" {
  description = "A list of security group IDs to associate with."
  type        = list(string)
  default     = null
}

variable "key_name" {
  description = "Key name of the Key Pair to use for the instance; which can be managed using the `aws_key_pair` resource."
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "The VPC Subnet ID to launch in."
  type        = string
  default     = null
}

variable "disable_api_stop" {
  description = "If true, enables EC2 Instance Stop Protection."
  type        = bool
  default     = false
}

variable "disable_api_termination" {
  description = "If true, enables EC2 Instance Termination Protection."
  type        = bool
  default     = true
}

