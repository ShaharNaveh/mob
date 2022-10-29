variable "name" {
  description = "Name of the ECR repository."
  type        = string
  nullable    = false
}

variable "image_tag_mutability" {
  description = "Whether or not to have mutable tags in the repository."
  default     = "MUTABLE"
  type        = string

  validation {
    condition     = contains(["IMMUTABLE", "MUTABLE"], var.image_tag_mutability)
    error_message = "var.image_tag_mutability can only be set to either 'IMMUTABLE' or 'MUTABLE'"
  }
}

variable "scan_on_push" {
  description = "Whether or not to scan the image on push."
  default     = false
  type        = bool
}

