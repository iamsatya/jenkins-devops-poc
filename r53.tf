module "us-east-1" {
  source = "./modules/r53"
  name   = "my-r53-hc"
  providers = {
    aws = "aws.us-east-1"
  }
}