terraform {
  backend "s3" {
    use_lockfile = true
    region       = "eu-central-1"
    profile      = "admin-study"
    bucket       = "terraform-state-bucket-852456"
    key          = "tests/architect/00/terraform.tfstate"
  }
}
