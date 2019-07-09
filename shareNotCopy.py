#!/usr/bin/env python3

import boto3
    
REGION = 'eu-west-1'
SOURCE_ACCOUNT = '411929112137'
TARGET_ACCOUNT = '445044146723'
ROLE_ON_TARGET_ACCOUNT = 'arn:aws:iam::445044146723:role/raf-copy-ami-role'

def role_arn_to_session(**args):
    client = boto3.client('sts')
    response = client.assume_role(**args)
    return boto3.Session(
        aws_access_key_id=response['Credentials']['AccessKeyId'],
        aws_secret_access_key=response['Credentials']['SecretAccessKey'],
        aws_session_token=response['Credentials']['SessionToken'])

source_ec2 = boto3.resource('ec2', region_name=REGION)
client2 = boto3.client('ec2', region_name=REGION)

lambda_return=[]

filters=[
        {'Name': 'tag:AmiStage2Version', 'Values': ['2']},
        {'Name': 'tag:Stage', 'Values': ['2']}                
]
for each in client2.describe_images(Owners=['self'], Filters=filters)['Images']:

    # --- action on source account ---

    print(f"Shared AMI id: {each['ImageId']}")
    myImage = each['ImageId']
    source_tags=each['Tags']
    client2.modify_image_attribute(
        ImageId=each['ImageId'],
        LaunchPermission={'Add': [{'UserId': TARGET_ACCOUNT}]}
    )
    lambda_return.append(myImage)

    # --- action on target account ---

    target_session = role_arn_to_session(
        RoleArn=ROLE_ON_TARGET_ACCOUNT,
        RoleSessionName='share-admin-temp-session'
    )
    target_ec2 = target_session.client('ec2', region_name=REGION)
    image2=target_ec2.describe_images(Filters=[{'Name': 'owner-id', 'Values': [SOURCE_ACCOUNT]}])['Images'] # is it needed?
    #image2_id=(image2[0]['ImageId'])
    target_ec2.create_tags(
        Resources=[myImage],
        Tags=each['Tags']
    )
print(lambda_return)
