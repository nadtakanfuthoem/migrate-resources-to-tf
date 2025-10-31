resource "aws_sqs_queue" "demo" {
  name = var.queue_name

  # Configuration matching your existing queue
  delay_seconds             = 0
  max_message_size = 1024
  message_retention_seconds = 345600
  receive_wait_time_seconds = 0
  visibility_timeout_seconds = 30

  # SQS-managed server-side encryption (as configured in your existing queue)
  sqs_managed_sse_enabled = true

  # Ignore changes to max_message_size due to provider validation vs actual AWS value
  lifecycle {
    ignore_changes = [max_message_size]
  }

  # Tags omitted to match existing queue (no tags currently set)
  # Uncomment if you want to add tags:
  # tags = {
  #   Name        = var.queue_name
  #   ManagedBy   = "Terraform"
  #   Environment = "production"
  # }
}
