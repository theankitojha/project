resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name              = "/ecs/my-app${local.environment_suffix}"
  retention_in_days = 14
}

resource "aws_cloudwatch_metric_alarm" "cpu_high" {
  alarm_name          = "high-cpu-alarm${local.environment_suffix}"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/ECS"
  period              = "300"
  statistic           = "Average"
  threshold           = "80"

  alarm_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_sns_topic" "alerts" {
  name = "ecs-alerts${local.environment_suffix}"
}

resource "aws_sns_topic_subscription" "alerts" {
  topic_arn = aws_sns_topic.alerts.arn
  protocol  = "email"
  endpoint  = "your-email@example.com"
}

