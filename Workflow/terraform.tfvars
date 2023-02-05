######################################################
# TAGS VALUES
######################################################
locationTag                 = "Krakow"
ownerTag                    = "Gauthier_Kwatatshey"
consumerTag                 = "Everyone_who_has_my_codes"
codes-ownerTag              = "Gauthier_Kwatatshey"
environmentTag              = "Dev"
data-classificationTag      = "Proprietary"
applicationTag              = "GOD"
terraform-github-repoTag    = "https://github.com/Assassin010/Step-Functions-G.git"
terraform-bitbucket-repoTag = "https://Assassin10@bitbucket.org/assassin10/step-functions-b.git"
terraform-gitlab-repoTag    = "https://gitlab.com/Assassin010/step-functions-l.git"
terraform-codes-pathTag     = "Workflow Different States"
linkedin-profileTag         = "https://www.linkedin.com/in/gauthier-kwatatshey-b9a66715b"

######################################################
# STEP FUNCTION - STATE MACHINE VARIABLES
######################################################
sfn_role_name     = "Step_Function_Role"
sfn_policy_name   = "Step_Function_Policy"
sfn_state_machine = "FirstStateMachine"

######################################################
# LAMBDA FUNCTION VALUES
######################################################
runtime                = "python3.8"
lambda_function_role   = "lambda_function_role"
lambda_function_policy = "lambda_function_policy"

######################################################
# MY GENERIC VARIABLES
######################################################
aws_account_id = "XXXXXXXXXXX"
aws_region     = "us-east-1"

######################################################
# STATE MACHINE RESOURCES ARN VALUES
######################################################
function_name1 = "adding_A_and_B"
function_name2 = "Increment_A"
function_name3 = "Increment_B"
function_name4 = "print_sum"
function_name5 = "format_inputs"

######################################################
# VALUES FOR AGIGW-SQS-LAMBDA
######################################################
environment = "dev"
name        = "sqs-integration"
lambda_name = "lambda-trigger-sfn"


default_project_type = "DEMO"


sqs_event_dlq_name = "Events_DLQ_T" #Events_DLQ

sns_topic_names = ["State-Machime-Status-Result", "State-Machine-ErrorMessages_T"]