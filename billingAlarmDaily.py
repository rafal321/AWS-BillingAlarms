#!/usr/bin/env python3
import boto3
import os
import datetime
import pprint
from datetime import date, timedelta
alarm_amount = 500
today = date.today()
yesterday = today - timedelta(days = 1)
today_str = today.strftime("%Y-%m-%d")
yesterday_str = yesterday.strftime("%Y-%m-%d")

client = boto3.client(service_name='ce', region_name='us-east-1')

response = client.get_cost_and_usage(
    TimePeriod={
        'Start': yesterday_str,
        'End': today_str 
    },
    Granularity='DAILY',
    Metrics=['UnblendedCost']
)
# pprint.pprint(response['ResultsByTime'])
# print(' --- Checkpoint 2 ---')
# print(response['ResultsByTime'][0]['Total']['UnblendedCost']['Amount'], type(response['ResultsByTime'][0]['Total']['UnblendedCost']['Amount']))
# print(' --- Checkpoint 3 ---')
previousDayCost = float(response['ResultsByTime'][0]['Total']['UnblendedCost']['Amount'])

if previousDayCost > alarm_amount:
    print('ALARM')
else:
    print('QUIET')

#==================================
