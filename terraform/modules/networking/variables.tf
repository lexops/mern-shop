variable "name" {
  type = string
}
variable "region" {
  type = string
}

variable "cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "tags" {
  type    = map(string)
  default = {}
}
