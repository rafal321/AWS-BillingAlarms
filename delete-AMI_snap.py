#!/usr/bin/env python3
# this Lambda Deregisters AMI and deletes Snapshots (optional)

import boto3
import pprint

delete_snap = True
regionSource = 'eu-west-1'
client = boto3.client('ec2', region_name=regionSource)
counter = 0

filters=[
        {'Name': 'tag:AmiStage2Version', 'Values': ['2']},
        {'Name': 'tag:Stage', 'Values': ['2']}                
]
for each in client.describe_images(Owners=['self'], Filters=filters)['Images']:
    counter += 1
    if delete_snap:
        client.deregister_image(ImageId=each['ImageId'])
        client.delete_snapshot(SnapshotId=each['BlockDeviceMappings'][0]['Ebs']['SnapshotId'])
        print(each['ImageId'], each['BlockDeviceMappings'][0]['Ebs']['SnapshotId'])
    else:
        client.deregister_image(ImageId=each['ImageId'])
        print(each['ImageId'])

if delete_snap:
    print(f">> {counter} AMI Deregistered & {counter} Snapshots Deleted <<")    
else:
    print(f">> {counter} AMI Deregistered <<")
