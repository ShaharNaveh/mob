variable "infrastructure_state_bucket" {
  description = "The name of the S3 bucket used for storing the Terraform state files and some artifacts."
  default     = "snaveh-mob20221024163346718300000001"
  type        = string
}

variable "aws_region" {
  description = "AWS region to deploy the resources in."
  default     = "eu-central-1"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR for the vpc of the cluster."
  type        = string
  default     = "192.168.0.0/16"
}

variable "cluster_name" {
  description = "Name for the EKS cluster."
  default     = "mob"
  type        = string
}

variable "azs_num" {
  description = "Number of AZs to have the cluster in. (minimum 2)"
  default     = 2
  type        = number

  validation {
    condition     = var.azs_num >= 2
    error_message = "Minimum number of AZs is 2 (EKS requirement)"
  }
}

