

provider "aws" {
  region  = var.region
}


resource "aws_cloudwatch_metric_alarm" "alarm1" {
  alarm_name                = "alarm1-${var.env}-${var.region}-lidoror-terra"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  alarm_actions       = terraform.workspace == "prod" ? [aws_sns_topic.alarms_sns_topic.arn] : []
 
}


resource "aws_cloudwatch_metric_alarm" "alarm2" {
  alarm_name                = "alarm1-${var.env}-${var.region}-lidoror-terra"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  alarm_actions       = terraform.workspace == "prod" ? [aws_sns_topic.alarms_sns_topic.arn] : []
  
}

resource "aws_cloudwatch_metric_alarm" "alarm3" {
  count = var.includeAlarm3inRegion ? 1 : 0
  alarm_name                = "alarm3-${var.env}-${var.region}-lidoror-terra"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "80"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  insufficient_data_actions = []
  alarm_actions       = terraform.workspace == "prod" ? [aws_sns_topic.alarms_sns_topic.arn] : []
  
}
//best practice is to use sns toic that is already working with client connected to it.
//or pass it as data source
resource "aws_sns_topic" "alarms_sns_topic" {
  name            = "alarm-sns"
  delivery_policy = jsonencode({
    "http" : {
      "defaultHealthyRetryPolicy" : {
        "minDelayTarget" : 20,
        "maxDelayTarget" : 20,
        "numRetries" : 3,
        "numMaxDelayRetries" : 0,
        "numNoDelayRetries" : 0,
        "numMinDelayRetries" : 0,
        "backoffFunction" : "linear"
      },
      "disableSubscriptionOverrides" : false,
      "defaultThrottlePolicy" : {
        "maxReceivesPerSecond" : 1
      }
    }
  })
}


resource "aws_sns_topic_subscription" "alarms_sns_topic_subs" {
  endpoint  = var.mailReceiver
  protocol  = "email"
  topic_arn = aws_sns_topic.alarms_sns_topic.arn
}