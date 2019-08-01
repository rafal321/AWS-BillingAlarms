import boto3
import os
import datetime
import pprint
from datetime import date, timedelta

alarm_amount = float(os.environ['alarmThreshold'])
accName = os.environ['accName']
today = date.today()
yesterday = today - timedelta(days = 1)
today_str = today.strftime("%Y-%m-%d")
yesterday_str = yesterday.strftime("%Y-%m-%d")

client1 = boto3.client(service_name='ce', region_name='us-east-1')
client2 = boto3.client(service_name='sns', region_name='us-east-1')
acc_ID = boto3.client('sts').get_caller_identity().get('Account')

def lambda_handler(event, context):

    # ==Ignore Service === START ===========================================================
    def service_ignore_cost():
        response2 = client1.get_cost_and_usage(
            TimePeriod={
                'Start': yesterday_str,
                'End': today_str 
            },
            Granularity='DAILY',
            Metrics=['UnblendedCost'],
            GroupBy=[{'Type': 'DIMENSION', 'Key': 'SERVICE'}]
        )
        total=0
        response3=(response2['ResultsByTime'])
        for r3 in response3:
            response4=(r3['Groups'])
            for r4 in response4:
                if ('Amazon Route 53' == r4['Keys'][0]) or ('Tax' == r4['Keys'][0]) or ('AWS Support (Business)' == r4['Keys'][0]):
                    total+=float(r4['Metrics']['UnblendedCost']['Amount'])    
        total_ignore=(round((total), 2))
        return total_ignore        
    
    
    response = client1.get_cost_and_usage(
    TimePeriod={
        'Start': yesterday_str,
        'End': today_str 
    },
    Granularity='DAILY',
    Metrics=['UnblendedCost']
    )
    
    previousDayCost = round((float(response['ResultsByTime'][0]['Total']['UnblendedCost']['Amount']) - service_ignore_cost()), 2)
    overspend = round((previousDayCost-alarm_amount), 2)
    
    
    if previousDayCost > alarm_amount:
        outputA=(f'ALARM - | Threshold: ${alarm_amount} | Actual cost: ${previousDayCost} | Overspend: ${overspend}')
        print(outputA)
        response = client2.publish(
            TopicArn=(f'arn:aws:sns:us-east-1:{acc_ID}:Daily-Billing-Alerts'),
            Message=(f" Account: {acc_ID} - {accName} \n ALARM - | Threshold: ${alarm_amount} | Actual cost: ${previousDayCost} | Overspend: ${overspend} - yesterday!"),
            Subject=(f'Billing ALERT - Daily cost exceeds ${alarm_amount} per day.')
        )
        return outputA 
    else:
        outputB=(f"QUIET - | Threshold: ${alarm_amount} | Actual cost: ${previousDayCost} | ${abs(overspend)} below budget.")
        print(outputB)
        return outputB
    
  #==================================================================================
CloudWatch Events
Daily-Billing-Alarm-ScheduledRule-1MU6GUPN9ABBR
arn:aws:events:us-east-1:888888888888:rule/Daily-Billing-Alarm-ScheduledRule-1MU6GUPN9ABBR
Description: ScheduledRuleForBillingAlarmsEvent bus: defaultSchedule expression: cron(0 3 * * ? *)
----------------            
 Environment variables:
        accName             OPER-AWS-Fri
        alarmThreshold      1.7
---------------------
to sa obie inline policies:
1) LambdaRolePolicy 
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ce:GetCostAndUsage"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}
2) root
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "cloudwatch:DeleteAlarms",
                "cloudwatch:DescribeAlarmHistory",
                "cloudwatch:DescribeAlarms",
                "cloudwatch:DescribeAlarmsForMetric",
                "cloudwatch:GetMetricStatistics",
                "cloudwatch:ListMetrics",
                "cloudwatch:PutMetricAlarm",
                "logs:CreateLogGroup",
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "sns:ListTopics",
                "sns:Publish",
                "sns:ListSubscriptionsByTopic",
                "sns:GetTopicAttributes",
                "sns:ListSubscriptions"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}






