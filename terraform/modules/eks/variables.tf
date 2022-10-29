variable "cluster_name" {
  description = "Name for the EKS cluster."
  default     = "mob"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes `<major>.<minor>` version to use for the EKS cluster."
  type        = string
  default     = null
}

variable "vpc_id" {
  description = "ID of the VPC where the cluster and its nodes will be provisioned."
  type        = string
}

variable "subnet_ids" {
  description = "A list of subnet IDs where the nodes/node groups will be provisioned."
  type        = list(string)
  default     = []
}

variable "enable_irsa" {
  description = "Determines whether to create an OpenID Connect Provider for EKS to enable IRSA."
  type        = bool
  default     = true
}

variable "eks_managed_node_groups" {
  description = "Map of EKS managed node group definitions to create"
  type        = any
  default     = {}
}

variable "create_cloudwatch_log_group" {
  description = "Whether a log group is created by this module for the cluster logs."
  type        = bool
  default     = false
}

variable "cluster_enabled_log_types" {
  description = "A list of the desired control plane logs to enable."
  type        = list(string)
  default     = []
}

variable "cluster_endpoint_public_access" {
  description = "Whether or not the Amazon EKS public API server endpoint is enabled."
  type        = bool
  default     = true
}
