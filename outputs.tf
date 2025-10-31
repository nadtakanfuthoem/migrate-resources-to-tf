output "queue_id" {
  description = "The URL of the SQS queue"
  value       = aws_sqs_queue.demo.id
}

output "queue_arn" {
  description = "The ARN of the SQS queue"
  value       = aws_sqs_queue.demo.arn
}

output "queue_name" {
  description = "The name of the SQS queue"
  value       = aws_sqs_queue.demo.name
}
