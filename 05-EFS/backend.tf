terraform {
  backend "s3" {
    use_lockfile = true
    profile      = "terraform-study"
    region       = "eu-central-1"
    bucket       = "terraform-state-bucket-852456"
    key          = "tests/architect/04/terraform.tfstate"
  }
}
