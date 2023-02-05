
######################################################
# TAGS VARIABLES
######################################################
variable "applicationTag" {
  type = string
}

variable "ownerTag" {
  type = string
}

variable "codes-ownerTag" {
  type = string
}

variable "consumerTag" {
  type = string
}

variable "locationTag" {
  type = string
}

variable "data-classificationTag" {
  type = string
}

variable "environmentTag" {
  type = string
}

variable "terraform-bitbucket-repoTag" {
  type = string
}

variable "terraform-github-repoTag" {
  type = string
}

variable "terraform-gitlab-repoTag" {
  type = string
}

variable "terraform-codes-pathTag" {
  type = string
}

variable "linkedin-profileTag" {
  type = string
}

######################################################
# LAMBDA FUNCTION VARIABLES
######################################################
variable "runtime" {
  description = "runtime"
  type        = string
}

variable "lambda_function_role" {
  type = string
}

variable "lambda_function_policy" {
  type = string
}

######################################################
# STEP FUNCTION - STATE MACHINE VARIABLES
######################################################
variable "sfn_role_name" {
  type = string
  validation {
    error_message = "Can include numbers, lowercase letters, uppercase letters, and hyphens (_). It cannot start or end with a hyphen (_)."
    condition     = can(regex("^Step_Function_Role*", var.sfn_role_name))
  }
}
variable "sfn_policy_name" {
  type = string
  validation {
    error_message = "Can include numbers, lowercase letters, uppercase letters, and hyphens (_). It cannot start or end with a hyphen (_)."
    condition     = can(regex("^Step_Function_Policy*", var.sfn_policy_name))
  }
}

variable "sfn_state_machine" {
  type = string
  validation {
    error_message = "Can include numbers, lowercase letters, uppercase letters, and hyphens (_). It cannot start or end with a hyphen (_)."
    condition     = can(regex("^FirstStateMachine*", var.sfn_state_machine))
  }

}

######################################################
# MY GENERIC VARIABLES
######################################################

variable "aws_region" {
  type = string
}

variable "aws_account_id" {
  type = string

}
######################################################
# VARIABLES TO BE USED ON STATE MACHINE RESOURCE ARN
######################################################
variable "function_name1" {
  type        = string
  description = "Adding 2 numbers"
}

variable "function_name2" {
  type        = string
  description = "Incrementing A"
}

variable "function_name3" {
  type        = string
  description = "Incrementing B"
}

variable "function_name4" {
  type        = string
  description = "Printing the sum"
}

variable "function_name5" {
  type        = string
  description = "Formatting the inputs"
}

######################################################
# VARIABLE FOR AGIGW-SQS-LAMBDA
######################################################
variable "environment" {
  description = "Env"
  type        = string
}

variable "name" {
  description = "Application Name"
  type        = string
}

locals {
  description = "Aplication Name"
  app_name    = "${var.name}-${var.environment}"
}

variable "lambda_name" {
  description = "Name for lambda function which trigger the step function"
  type        = string
}

variable "default_project_type" {
  description = "Default project type for tagging purpose"
  type        = string
}

variable "sqs_event_dlq_name" {
  description = "sqs events dlq"
  type        = string
}

variable "sns_topic_names" {
  type        = list(string)
  description = "sns topic name"
}