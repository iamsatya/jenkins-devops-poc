provider "aws" {
  profile    = "${var.profile}"
  region     = "${var.region}"
}

terraform {
  backend "s3" {
    bucket = "jenkins-devops-poc-backend"
    key    = "dev"
    region = "ap-south-1"
  }
}