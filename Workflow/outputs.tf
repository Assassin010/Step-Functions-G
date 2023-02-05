output "step_function_status" {
  value = aws_sfn_state_machine.sfn_state_machine.status
}

output "step_function_arn" {
  value = aws_sfn_state_machine.sfn_state_machine.arn
}


output "step_function_arns" {
  value = toset(values(aws_lambda_function.functions)[*].arn)
}

output "url" {
  value = "${aws_api_gateway_deployment.api.invoke_url}/startStepFunctions"
}