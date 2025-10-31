resource "aws_sqs_queue" "demo" {
  name = var.queue_name

  # Add additional configuration as needed
  # Uncomment and adjust based on your queue's actual settings:

  # delay_seconds             = 0
  # max_message_size          = 262144
  # message_retention_seconds = 345600
  # receive_wait_time_seconds = 0
  # visibility_timeout_seconds = 30

  # If FIFO queue:
  # fifo_queue                  = true
  # content_based_deduplication = false

  # If encrypted:
  # kms_master_key_id = "alias/aws/sqs"
  # sqs_managed_sse_enabled = true

  tags = {
    Name        = var.queue_name
    ManagedBy   = "Terraform"
    Environment = "production"
  }
}
