resource "aws_sqs_queue" "queue" {
  name                      = "API-Gateway-Queue"
  delay_seconds             = 0
  max_message_size          = 262144
  message_retention_seconds = 86400
  receive_wait_time_seconds = 10

  tags = {
    Product                  = local.app_name
    Location                 = var.locationTag
    Account-owner            = var.ownerTag
    Consumer                 = var.consumerTag
    Codes-owner              = var.codes-ownerTag
    Environment              = var.environmentTag
    Data-classification      = var.data-classificationTag
    Application              = var.applicationTag
    Terraform-github-repo    = var.terraform-github-repoTag
    Terraform-bitbucket-repo = var.terraform-bitbucket-repoTag
    Terraform-gitlab-repo    = var.terraform-gitlab-repoTag
    Terraform-codes-path     = var.terraform-codes-pathTag
    Linkedin-profile         = var.linkedin-profileTag
  }
}

# Trigger lambda on message to SQS
resource "aws_lambda_event_source_mapping" "event_source_mapping" {
  batch_size       = 1
  event_source_arn = aws_sqs_queue.queue.arn
  enabled          = true
  function_name    = aws_lambda_function.lambda_sqs.arn
}