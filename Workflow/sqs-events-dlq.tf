resource "aws_sqs_queue" "Events_DLQ" {
  name = var.sqs_event_dlq_name
}