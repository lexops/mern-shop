variable "project_name" {
  description = "The name of the project. Defaults to mern-shop"
  type        = string
  default     = "mern-shop"
}

variable "region" {
  description = "The region to deploy the project, e.g. us-east-1. Required"
  type        = string
}

variable "domain" {
  description = "The domain to deploy the project on, e.g. dev.example.com. Required"
  type        = string
}

variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default = {
    Team        = "DevOps"
    Environment = "Dev"
  }
}
