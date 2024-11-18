variable "name" {
  type        = string
  description = "The name of the secret"
}

variable "tags" {
  type        = map(string)
  description = "The tags to apply to the secret"
}
