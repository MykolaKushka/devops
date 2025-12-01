terraform {
  backend "s3" {
    bucket         = "mykola-lesson-5-tf-state"
    key            = "lesson-5/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform-locks"
    encrypt        = true
  }
}
