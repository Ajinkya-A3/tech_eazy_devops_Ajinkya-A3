resource "aws_sns_topic" "app_alerts" {
  name = "app-alerts-topic"
}

resource "aws_sns_topic_subscription" "email_alert" {
  topic_arn = aws_sns_topic.app_alerts.arn
  protocol  = "email"
  endpoint  = "ajinkyaa3xd@gmail.com"
}
