terraform {
  backend "s3" {
    bucket         = "lesson-9-mykola-kushka-tfstate-001"
    key            = "lesson-9/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "lesson-9-terraform-locks"
    encrypt        = true
  }
}
