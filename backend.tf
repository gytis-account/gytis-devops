terraform {
  backend "s3" {
    bucket  = "atlantis-bucket-gytis"
    key     = "state-files/atlantis.tfstate"
    region  = "eu-north-1"
    encrypt = true
  }
}