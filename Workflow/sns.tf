resource "aws_sns_topic" "STATES-Status" {
 count = length(var.sns_topic_names)
 name = var.sns_topic_names[count.index]
}

/* resource "aws_sns_topic" "STATES-ErrorMessages" {
  name = "ETLErrorMessages_T"
} */

resource "aws_sns_topic_subscription" "STATES-Status_target" {
  topic_arn = aws_sns_topic.STATES-Status[0].arn
  protocol  = "email"
  endpoint  = "Put your email address here"

  depends_on = [
    aws_sns_topic.STATES-Status[0]
  ]
}

resource "aws_sns_topic_subscription" "STATES-ErrorMessages_target" {
  topic_arn = aws_sns_topic.STATES-Status[1].arn
  protocol  = "email"
  endpoint  = "Put your email address here"

  depends_on = [
    aws_sns_topic.STATES-Status[1]
  ]
}