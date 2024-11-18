terraform {
  backend "s3" {
    bucket  = "desafio-hotmart-tfstate"
    key     = "terraform.tfstate"
    region  = "us-east-1"
    encrypt = true
  }
}
