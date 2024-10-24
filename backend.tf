/*terraform {
  backend "s3" {
    bucket  = "Atlantis-Bucket-Gytis"
    key     = "state-files/atlantis.tfstate"
    region  = "eu-north-1"
    encrypt = true
  }
}*/

terraform {
  backend "local" {
    path = "terraform.tfstate"
  }
}