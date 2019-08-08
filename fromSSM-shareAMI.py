#08/08/2019 share AMI and copy tags to shared AMIs

import json
import boto3
import os

def role_arn_to_session(**args):
    client = boto3.client('sts')
    response = client.assume_role(**args)
    return boto3.Session(
        aws_access_key_id=response['Credentials']['AccessKeyId'],
        aws_secret_access_key=response['Credentials']['SecretAccessKey'],
        aws_session_token=response['Credentials']['SessionToken'])

def lambda_handler(event, context):
    
    region = event['region'] # 'eu-west-1'
    version = event['version'] #'2'
    target_account = '445044146723' #event['target_account'] # '445044146723'
    role_on_target_account = (f"arn:aws:iam::{target_account}:role/raf-copy-ami-role")
    
    client2 = boto3.client('ec2', region_name=region)
    
    lambda_return=[]
    
    filters=[
            {'Name': 'tag:AmiStage2Version', 'Values': [version]},
            {'Name': 'tag:Stage', 'Values': ['2']}                
    ]
    print('checkpoint-1')
    for each in client2.describe_images(Owners=['self'], Filters=filters)['Images']:
    
        # --- action on source account ---
        print('checkpoint-2')
        print(f"Shared AMI id: {each['ImageId']}")
        myImage = each['ImageId']
        print(myImage)
        source_tags=each['Tags']
        client2.modify_image_attribute(
            ImageId=each['ImageId'],
            LaunchPermission={'Add': [{'UserId': target_account}]}
        )
        lambda_return.append(myImage)
    
        # --- action on target account ---
    
        target_session = role_arn_to_session(
            RoleArn=role_on_target_account,
            RoleSessionName='share-admin-temp-session'
        )
        target_ec2 = target_session.client('ec2', region_name=region)
        target_ec2.create_tags(
            Resources=[myImage],
            Tags=each['Tags']
        )
    print(lambda_return)
    return lambda_return
    
    ===SSM===
 # Roles FOR SSM: managed roles:    AmazonEC2RoleforSSM, AmazonSSMAutomationRole, AWSLambdaRole
    
{
  "outputs": [
    "ShareImage.Payload"
  ],
  "schemaVersion": "0.3",
  "description": "This automation document copies Stage 1 AMI's from Image Factory Account to any AWS Account. Note:AWS Account must have Role associated to allow update TAG's.",
  "assumeRole": "arn:aws:iam::411929112137:role/raf-ssmRoleforEC2",
  "parameters": {
    "targetaccount": {
      "default": "445044146723",
      "description": "Please provide an account to share AMI with",
      "type": "String"
    },
    "AmiStage1Version": {
      "description": "Golden AMI Stage 1 Image version",
      "type": "String"
    },
    "region": {
      "default": "eu-west-1",
      "description": "Region where Source Should be Exported. Use One of the listed Regions:   US East (Ohio)  us-east-2, US East (N. Virginia) us-east-1, US West (N. California) us-west-1, US West (Oregon) us-west-2, Asia Pacific (Hong Kong)  ap-east-1, Asia Pacific (Mumbai) ap-south-1, Asia Pacific (Seoul)  ap-northeast-2,   Asia Pacific (Sydney) ap-southeast-2, Asia Pacific (Tokyo)  ap-northeast-1, Canada (Central)  ca-central-1, China (Beijing) cn-north-1, China (Ningxia) cn-northwest-1, EU (Frankfurt)  eu-central-1, EU (Ireland)  eu-west-1, EU (London) eu-west-2,   EU (Paris)  eu-west-3, EU (Stockholm)  eu-north-1 , South America (São Paulo) sa-east-1 , AWS GovCloud (US-East)  us-gov-east-1 , AWS GovCloud (US) us-gov-west-1 . ",
      "type": "String"
    }
  },
  "mainSteps": [
    {
      "maxAttempts": 3,
      "inputs": {
        "FunctionName": "shareNotCopy",
        "Payload": "{\"region\":\"{{region}}\", \"target_account\":\"{{targetaccount}}\", \"version\":\"{{AmiStage1Version}}\"}              "
      },
      "name": "ShareImage",
      "action": "aws:invokeLambdaFunction",
      "timeoutSeconds": 120,
      "onFailure": "Abort"
    }
  ]
}
=============
# Role on target account +  # trust relationship

{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "ec2:CopySnapshot",
                "ec2:CreateTags",
                "ec2:RegisterImage",
                "ec2:Describe*",
                "kms:*"
            ],
            "Resource": "*",
            "Effect": "Allow"
        }
    ]
}

 {
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::779692436362:root",
        "Service": "lambda.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}



