# Generated by Terragrunt. Sig: nIlQXj57tbuaRZEa
terraform {
  backend "s3" {
    bucket         = "krakow-terraform-state"
    dynamodb_table = "krakow-lock-table"
    encrypt        = true
    key            = "Workflow/terraform.tfstate"
    region         = "us-east-1"
  }
}