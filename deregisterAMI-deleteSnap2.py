#!/usr/bin/env python3
# ver-1
# this Lambda deregisters AMI and deletes Snapshots (optional)


import boto3
import pprint

delete_snap = ('asdaddasd'.lower())     # nie dziala True/False na AWS
region = 'eu-west-1'
stage = '5'
client = boto3.client('ec2', region_name=region)

counter = 0
lambda_return=[]

filters=[
        {'Name': 'tag:AmiStage2Version', 'Values': ['2']},
        {'Name': 'tag:Stage', 'Values': [stage]}                
]
for each in client.describe_images(Owners=['self'], Filters=filters)['Images']:
    counter += 1
    if delete_snap == 'yes':
        # client.deregister_image(ImageId=each['ImageId'])
        # try:                                                
        #     client.delete_snapshot(SnapshotId=each['BlockDeviceMappings'][0]['Ebs']['SnapshotId'])
        # except Exception:
        #     pass
        result=(each['ImageId'], each['BlockDeviceMappings'][0]['Ebs']['SnapshotId'])
        print(result)
        lambda_return.append(result)
        print('--checkpoint2')
    else:
        #client.deregister_image(ImageId=each['ImageId'])
        result=(each['ImageId'])
        print(result)
        lambda_return.append(result)
        print('--checkpoint3')

if delete_snap == 'yes':
    print(f">> {counter} AMI Deregistered & Snapshots Deleted <<")    
else:
    print(f">> {counter} AMI Deregistered <<")

print(lambda_return)

# # =======================================================================================
#     region = os.environ['region']               #'eu-west-1'
#     stage = os.environ['stage']                 #'5'
#     delete_snap = os.environ['delete_snap']     #True         EXAMPLE:     version = event['version']




# #------LANBDA PREMISSIONS-----------------------
# {
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Sid": "VisualEditor0",
#             "Effect": "Allow",
#             "Action": [
#                 "ec2:DeleteSnapshot",
#                 "ec2:DeleteTags",
#                 "logs:PutLogEvents"
#             ],
#             "Resource": [
#                 "arn:aws:logs:*:*:log-group:*:*:*",
#                 "arn:aws:ec2:*::snapshot/*",
#                 "arn:aws:ec2:*::image/*"
#             ]
#         },
#         {
#             "Sid": "VisualEditor1",
#             "Effect": "Allow",
#             "Action": [
#                 "logs:CreateLogStream",
#                 "logs:PutLogEvents"
#             ],
#             "Resource": "arn:aws:logs:*:*:log-group:*"
#         },
#         {
#             "Sid": "VisualEditor2",
#             "Effect": "Allow",
#             "Action": [
#                 "ec2:DescribeImages",
#                 "ec2:DeregisterImage",
#                 "ec2:DescribeVolumeStatus",
#                 "ec2:DescribeTags",
#                 "ec2:DescribeRegions",
#                 "ec2:DescribeVolumes",
#                 "logs:CreateLogGroup"
#             ],
#             "Resource": "*"
#         }
#     ]
# }

#  -----SSM PART -----------------------
#  {
#   "outputs": [
#     "deregisterAMIdeleteSnap.Payload"
#   ],
#   "schemaVersion": "0.3",
#   "description": "This automation document deregisters AMI and deletes snapshots (optional)",
#   "assumeRole": "arn:aws:iam::411929112137:role/raf-ssmRoleforEC2",
#   "parameters": {
#     "deletesnap": {
#       "default": "True",
#       "description": "Delete snapshots as well? True/False",
#       "type": "String"
#     },
#     "AmiStage": {
#       "description": "Stage",
#       "type": "String"
#     },
#     "region": {
#       "default": "eu-west-1",
#       "description": "Example: us-east-2, us-east-1, us-west-1 ...",
#       "type": "String"
#     }
#   },
#   "mainSteps": [
#     {
#       "maxAttempts": 3,
#       "inputs": {
#         "FunctionName": "deregisterAMIdeleteSnap",
#         "Payload": "{\"region\":\"{{region}}\", \"delete_snap\":\"{{deletesnap}}\", \"stage\":\"{{AmiStage}}\"}"
#       },
#       "name": "deregisterAMIdeleteSnap",
#       "action": "aws:invokeLambdaFunction",
#       "timeoutSeconds": 120,
#       "onFailure": "Abort"
#     }
#   ]
# }




##======================================
# ROLE FOR SHARING{
#     "Version": "2012-10-17",
#     "Statement": [
#         {
#             "Effect": "Allow",
#             "Action": [
#                 "ec2:CopySnapshot",
#                 "ec2:CreateTags",
#                 "ec2:RegisterImage",
#                 "ec2:Describe*",
#                 "kms:*"
#             ],
#             "Resource": "*"
#         }
#     ]
# }
