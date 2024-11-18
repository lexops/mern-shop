variable "name" {
  description = "EKS Cluster Name"
  type        = string
}

variable "vpc_id" {
  description = "EKS VPC ID"
  type        = string
}

variable "subnet_ids" {
  description = "EKS Subnet IDs"
  type        = list(string)
}

variable "tags" {
  description = "EKS Tags"
  type        = map(string)
  default     = {}
}

variable "spot" {
  description = "Whether to use spot instances or not"
  type        = bool
  default     = false
}
