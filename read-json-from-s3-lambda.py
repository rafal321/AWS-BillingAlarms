#!/usr/bin/env python
# reads and parses json file from s3
import boto3
import json

s3 = boto3.resource('s3')

content_object = s3.Object('raflinux', 'sample_json.json')
print(content_object)
file_content = content_object.get()['Body'].read().decode('utf-8')
print(file_content)
json_content = json.loads(file_content)
print(json_content['Details'])
print(json_content['Regions'])
print(json_content['Regions'][1])
print('--------------------')
for r in json_content['Regions']:
    print(r)

# sample_json.json
# {
#   "Details" : "Something",
#   "Regions": ["eu-west-2", "eu-central-1"]
# }
