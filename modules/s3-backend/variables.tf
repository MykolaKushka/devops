variable "bucket_name" {
  description = "Name of the S3 bucket for Terraform state"
  type        = string
}

variable "table_name" {
  description = "Name of the DynamoDB table for Terraform state locking"
  type        = string
}

variable "tags" {
  description = "Common tags for resources"
  type        = map(string)
  default = {
    Project   = "lesson-9"
    Terraform = "true"
  }
}
