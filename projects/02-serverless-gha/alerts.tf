variable "alerts_email" {
  type        = string
  description = "Email to receive serverless alarms"
  default     = ""
}

resource "aws_sns_topic" "serverless_alarms" {
  name = "${var.project}-${var.env}-serverless-alarms"
}

resource "aws_sns_topic_subscription" "email" {
  count     = var.alerts_email != "" ? 1 : 0
  topic_arn = aws_sns_topic.serverless_alarms.arn
  protocol  = "email"
  endpoint  = var.alerts_email
}