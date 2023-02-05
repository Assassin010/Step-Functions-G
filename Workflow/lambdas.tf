######################################################
# LAMBDA FUNCTIONS
######################################################
resource "aws_lambda_function" "functions" {
  for_each         = local.functions
  function_name    = each.key
  role             = aws_iam_role.iam_for_lfn.arn
  runtime          = var.runtime
  handler          = each.value.handler
  source_code_hash = each.value.source_code_hash
  filename         = each.value.filename
  tags = {
    Name                     = "Lambda_Function"
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

locals {
  functions = {
    adding_A_and_B = { # function1
      handler          = "function1.lambda_handler"
      source_code_hash = filebase64sha256("function1.zip")
      filename         = "function1.zip"
    }
    Increment_A = { # function2
      handler          = "function2.lambda_handler"
      source_code_hash = filebase64sha256("function2.zip")
      filename         = "function2.zip"
    }
    Increment_B = { # function3
      handler          = "function3.lambda_handler"
      source_code_hash = filebase64sha256("function3.zip")
      filename         = "function3.zip"
    }
    print_sum = { # function4
      handler          = "function4.lambda_handler"
      source_code_hash = filebase64sha256("function4.zip")
      filename         = "function4.zip"
    }
    format_inputs = { # function5
      handler          = "function5.lambda_handler"
      source_code_hash = filebase64sha256("function5.zip")
      filename         = "function5.zip"
    }
  }
}


data "archive_file" "functions" {
  type        = "zip"
  for_each    = local.default #In case you decide to use variable (for_each = var.archive_file)
  output_path = each.value.output_path
  source_file = each.value.source_file # If lambda is in the root direcoty (working directory)
}
# However I decide to use local form here instead of variable
locals {
  default = {
    function1 = {
      output_path = "function1.zip" # If lambda is in the root direcoty (working directory)
      source_file = "function1.py"  # If lambda is in the root direcoty (working directory)
    }
    function2 = {
      output_path = "function2.zip"
      source_file = "function2.py"
    }
    function3 = {
      output_path = "function3.zip"
      source_file = "function3.py"
    }
    function4 = {
      output_path = "function4.zip"
      source_file = "function4.py"
    }
    function5 = {
      output_path = "function5.zip"
      source_file = "function5.py"
    }
  }
}

# In case you decide to use variable instead of locals
/* variable "archive_file" {
  description = "archive files"
  default = {
    function1 = {
      output_path = "function1.zip"
      source_file = "function1.py"
    }
    function2 = {
      output_path = "function2.zip"
      source_file = "function2.py"
    }
    function3 = {
      output_path = "function3.zip"
      source_file = "function3.py"
    }
    function4 = {
      output_path = "function4.zip"
      source_file = "function4.py"
    }
    function5 = {
      output_path = "function5.zip"
      source_file = "function5.py"
    }
  }
} */


######################################################
# LAMBDA FUNCTION ROLE
######################################################
resource "aws_iam_role" "iam_for_lfn" {
  name = var.lambda_function_role
  # Terraform's "jsonencode" function converts a
  # Terraform expression result to valid JSON syntax.
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      },
    ]
  })

  tags = {
    Name                     = "Lambda_Function_role"
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


######################################################
# LAMBDA FUNCTION POLICY
######################################################

data "aws_iam_policy_document" "lfn_policy_doc" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
    ]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"
      values   = ["us-east-1"]
    }
  }
}

resource "aws_iam_policy" "lfn_policy" {
  name        = var.lambda_function_policy
  description = "lambda-function-policy"
  policy      = data.aws_iam_policy_document.lfn_policy_doc.json
}

######################################################
# LAMBDA FUNCTION POLICY ATTACHMENT
######################################################

resource "aws_iam_role_policy_attachment" "lfn-policy-attach" {
  role       = aws_iam_role.iam_for_lfn.name
  policy_arn = aws_iam_policy.lfn_policy.arn
  depends_on = [
    aws_iam_role.iam_for_lfn,
    aws_iam_policy.lfn_policy
  ]
}

resource "aws_cloudwatch_log_group" "logs" {
  for_each          = local.functions
  name              = "/aws/lambda/${aws_lambda_function.functions[each.key].function_name}"
  retention_in_days = 14
}