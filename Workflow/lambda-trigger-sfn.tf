data "archive_file" "lambda_with_dependencies" {
  source_dir  = "lambda-trigger-sfn/"
  output_path = "lambda-trigger-sfn/${local.app_name}-${var.lambda_name}.zip"
  type        = "zip"
}

resource "aws_lambda_function" "lambda_sqs" {
  function_name = "${local.app_name}-${var.lambda_name}"
  handler       = "handler.lambda_handler"
  role          = aws_iam_role.lambda_exec_role.arn
  runtime       = "python3.7"

  filename         = data.archive_file.lambda_with_dependencies.output_path
  source_code_hash = data.archive_file.lambda_with_dependencies.output_base64sha256

  timeout     = 30
  memory_size = 128

  depends_on = [
    aws_iam_role_policy_attachment.lambda_role_policy
  ]
  tags = {
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

resource "aws_lambda_permission" "allows_sqs_to_trigger_lambda" {
  statement_id  = "AllowExecutionFromSQS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.lambda_sqs.function_name
  principal     = "sqs.amazonaws.com"
  source_arn    = aws_sqs_queue.queue.arn
}