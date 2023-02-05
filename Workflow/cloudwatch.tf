#EventBridge Events

resource "aws_cloudwatch_event_rule" "state_machine_events_failed" {
  name        = "state_machine_events_failed_t"
  description = "This event is triggered when the state machine fails."

  event_pattern = <<EOF
{
  "source": ["aws.states"],
  "detail-type": ["Step Functions Execution Status Change"],
  "detail": {
    "status": ["FAILED"],
    "stateMachineArn": ["${aws_sfn_state_machine.sfn_state_machine.arn}"]
  }
}
EOF

depends_on = [
  aws_sfn_state_machine.sfn_state_machine
]
}

#EventBridge Event Targets

resource "aws_cloudwatch_event_target" "sns" {
  rule      = aws_cloudwatch_event_rule.state_machine_events_failed.name
  target_id = "SendToSNS"
  arn       = aws_sns_topic.STATES-Status[1].arn

  depends_on = [
    aws_cloudwatch_event_rule.state_machine_events_failed,
    aws_sns_topic.STATES-Status[1]
  ]
}

resource "aws_cloudwatch_event_target" "sqs" {
  rule      = aws_cloudwatch_event_rule.state_machine_events_failed.name
  target_id = "SendToSQS"
  arn       = aws_sqs_queue.Events_DLQ.arn

  depends_on = [
    aws_cloudwatch_event_rule.state_machine_events_failed,
    aws_sqs_queue.Events_DLQ
  ]
}

resource "aws_cloudwatch_event_target" "cloudwatch_logs" {
  rule      = aws_cloudwatch_event_rule.state_machine_events_failed.name
  target_id = "SendToCloudwatchLogs"
  arn       = aws_cloudwatch_log_group.log_group.arn

  depends_on = [
    aws_cloudwatch_event_rule.state_machine_events_failed,
    aws_cloudwatch_log_group.log_group
  ]
}

#Cloudwatch Log Group

resource "aws_cloudwatch_log_group" "log_group" {
  name = "state_machine_events_failed_t"
}