resource "aws_cloudwatch_log_group" "app_logs" {
  name              = "app-log-group"
  retention_in_days = 7
}


resource "aws_cloudwatch_log_metric_filter" "error_filter" {
  name           = "app-error-filter"
  log_group_name = aws_cloudwatch_log_group.app_logs.name
  pattern        = "ERROR "

  metric_transformation {
    name      = "AppErrorCount"
    namespace = "AppLogs"
    value     = "1"
  }
}

resource "aws_cloudwatch_metric_alarm" "error_alarm" {
  alarm_name          = "app-error-alarm"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = aws_cloudwatch_log_metric_filter.error_filter.metric_transformation[0].name
  namespace           = "AppLogs"
  period              = 60
  statistic           = "Sum"
  threshold           = 1

  alarm_description = "Triggers if error logs appear"
  alarm_actions     = [aws_sns_topic.app_alerts.arn]
}
