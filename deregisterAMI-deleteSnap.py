#!/usr/bin/env python3
# this Lambda deregisters AMI and deletes Snapshots (optional)

import boto3
import pprint

delete_snap = True
regionSource = 'eu-west-1'
client = boto3.client('ec2', region_name=regionSource)
counter = 0
lambda_return=[]

filters=[
        {'Name': 'tag:AmiStage2Version', 'Values': ['2']},
        {'Name': 'tag:Stage', 'Values': ['2']}                
]
for each in client.describe_images(Owners=['self'], Filters=filters)['Images']:
    counter += 1
    if delete_snap:
        client.deregister_image(ImageId=each['ImageId'])
        try:                                                # need this if many AMI linked to one snap
            client.delete_snapshot(SnapshotId=each['BlockDeviceMappings'][0]['Ebs']['SnapshotId'])
        except Exception:
            pass
        result=(each['ImageId'], each['BlockDeviceMappings'][0]['Ebs']['SnapshotId'])
        print(result)
        lambda_return.append(result)
    else:
        client.deregister_image(ImageId=each['ImageId'])
        result=(each['ImageId'])
        print(result)
        lambda_return.append(result)

if delete_snap:
    print(f">> {counter} AMI Deregistered & Snapshots Deleted <<")    
else:
    print(f">> {counter} AMI Deregistered <<")

print(lambda_return)
