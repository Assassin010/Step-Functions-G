######################################################
# STEP FUNCTION ROLE
######################################################
resource "aws_iam_role" "iam_for_sfn" {
  name = var.sfn_role_name
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
          Service = ["states.amazonaws.com", "apigateway.amazonaws.com", "lambda.amazonaws.com"]
        }
      },
    ]
  })

  tags = {
    Name                     = "Step_Function_State_Machine_role"
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
# STEP FUNCTION POLICY
######################################################
data "aws_iam_policy_document" "sfn_policy_doc" {
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["lambda:InvokeFunction"]

    condition {
      test     = "StringEquals"
      variable = "aws:RequestedRegion"
      values   = ["us-east-1"]
    }
  }
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions   = ["states:StartExecution"]

  }
  statement {
    sid       = ""
    effect    = "Allow"
    resources = ["*"]
    actions = ["execute-api:Invoke",
    "execute-api:ManageConnections"]

  }
  statement {
    sid       = ""
    effect    = "Allow"
    resources  = ["*"]
    actions   = ["sns:Publish"]
  }
}

resource "aws_iam_policy" "sfn_policy" {
  name        = var.sfn_policy_name
  description = "state-machine-policy"
  policy      = data.aws_iam_policy_document.sfn_policy_doc.json
}
######################################################
# STEP FUNCTION POLICY ATTACHMENT
######################################################


resource "aws_iam_role_policy_attachment" "sfn-policy-attach" {
  role       = aws_iam_role.iam_for_sfn.name
  policy_arn = aws_iam_policy.sfn_policy.arn
  depends_on = [
    aws_iam_role.iam_for_sfn,
    aws_iam_policy.sfn_policy
  ]
}


######################################################
# STEP FUNCTION STATE MACHINE
######################################################
resource "aws_sfn_state_machine" "sfn_state_machine" {
  name       = var.sfn_state_machine
  role_arn   = aws_iam_role.iam_for_sfn.arn
  definition = <<EOF
{
  "Comment": "An example of the Amazon States Language using different states",
  "StartAt": "AplusB",
  "States": {
    "AplusB": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:${var.aws_region}:${var.aws_account_id}:function:${var.function_name1}",
      "Next": "CheckAplusB"
    },
    "CheckAplusB": {
      "Type": "Choice",
      "Choices": [
        {
          "Variable": "$.sumAB",
          "NumericGreaterThanEquals": 10,
          "Next": "PrintResults"
        },
        {
          "Variable": "$.sumAB",
          "NumericLessThan": 10,
          "Next": "IncrementAB"
        }
      ]
    },
    "PrintResults": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:${var.aws_region}:${var.aws_account_id}:function:${var.function_name4}",
      "Next": "Notify"
    },
    "Notify": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sns:publish",
      "Parameters": {
        "TopicArn": "arn:aws:sns:${var.aws_region}:${var.aws_account_id}:State-Machime-Status-Result",
        "Message.$": "$"
      },
      "End": true
    },
    "IncrementAB": {
      "Type": "Parallel",
      "Next": "FormatInputs",
      "Branches": [
        {
          "StartAt": "IncrementA",
          "States": {
            "IncrementA": {
              "Type": "Task",
              "Resource": "arn:aws:lambda:${var.aws_region}:${var.aws_account_id}:function:${var.function_name2}",
              "End": true
            }
          }
        },
        {
          "StartAt": "IncrementB",
          "States": {
            "IncrementB": {
              "Type": "Task",
              "Resource": "arn:aws:lambda:${var.aws_region}:${var.aws_account_id}:function:${var.function_name3}",
              "End": true
            }
          }
        }
      ]
    },
    "FormatInputs": {
      "Type": "Task",
      "Resource": "arn:aws:lambda:${var.aws_region}:${var.aws_account_id}:function:${var.function_name5}",
      "Next": "Wait_10_Seconds"
    },
    "Wait_10_Seconds": {
      "Type": "Wait",
      "Seconds": 10,
      "Next": "AplusB"
    }

  }
}
EOF
  tags = {
    Name                     = "Step_Function_State_Machine"
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

  depends_on = [
    aws_sns_topic.STATES-Status,
    aws_lambda_function.functions,
    aws_iam_role.iam_for_sfn

  ]
}

######################

