resource "aws_cloudtrail" "main" {
  name                          = var.trail_name
  s3_bucket_name                = aws_s3_bucket.cloudtrail_logs.bucket
  include_global_service_events = true
  is_multi_region_trail         = true
  enable_log_file_validation    = true
  kms_key_id                    = aws_kms_key.cloudtrail.arn

  event_selector {
    read_write_type           = "All"
    include_management_events = true
  }

  depends_on = [
    aws_s3_bucket_policy.cloudtrail_logs,
    aws_s3_bucket_server_side_encryption_configuration.cloudtrail_logs
  ]
}

output "cloudtrail_bucket" {
  value = aws_s3_bucket.cloudtrail_logs.bucket
}

output "cloudtrail_trail_name" {
  value = aws_cloudtrail.main.name
}