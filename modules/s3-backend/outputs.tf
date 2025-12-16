output "bucket_name" {
  description = "Name of the S3 bucket"
  value       = aws_s3_bucket.tf_state.id
}

output "bucket_arn" {
  description = "ARN of the S3 bucket"
  value       = aws_s3_bucket.tf_state.arn
}

output "dynamodb_table_name" {
  description = "DynamoDB table name"
  value       = aws_dynamodb_table.tf_locks.name
}

output "dynamodb_table_arn" {
  description = "DynamoDB table ARN"
  value       = aws_dynamodb_table.tf_locks.arn
}
