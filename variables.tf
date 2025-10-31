variable "aws_region" {
  description = "AWS region where the SQS queue is located"
  type        = string
  default     = "us-east-1"
}

variable "queue_name" {
  description = "Name of the SQS queue"
  type        = string
  default     = "demo"
}

variable "aws_profile" {
  description = "AWS profile to use for authentication"
  type        = string
  default     = "sandbox"
}
