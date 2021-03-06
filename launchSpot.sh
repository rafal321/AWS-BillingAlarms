#!/bin/bash
# launch.sh
# 2019-10-05 this launches single spot instance created for testing databases
set -e
REGION="eu-west-1"
INSTANCE_TYPE="t3.small" # value to be changed in spec.json file
echo $(($(cat COUNTER.file)+1)) > COUNTER.file
COUNTER=$(cat COUNTER.file)
echo "${COUNTER}" > COUNTER.file
NAMETAGVALUE="${COUNTER}-RafDB-spot-test"

echo -e "   \e[95m*** \e[96mLaunching spot instance \e[95m***"

# asking for price
PRICE=$(aws --region=${REGION} ec2 describe-spot-price-history --instance-types ${INSTANCE_TYPE} --start-time=$(date +%s) --product-descriptions="Linux/UNIX" --query 'SpotPriceHistory[*].{az:AvailabilityZone, price:SpotPrice}' --output text | grep ${REGION}a | cut -f2)

# just info output
echo -e "   \e[95mInstance spot price in \e[97m${REGION} \e[95mfor \e[97m${INSTANCE_TYPE} \e[95mis: \e[97m${PRICE}"
sleep 1

# spot instance request
aws ec2 request-spot-instances --spot-price "${PRICE}" --instance-count 1 --type "one-time" --launch-specification file://spec.json > /dev/null 2>&1

sleep 3
# tag instance
echo -e "   \e[95mTagging spot instance"
TAGTHIS=$(aws ec2 describe-spot-instance-requests --output text | awk '/SPOTINSTANCEREQUESTS/ && /active/' | cut -f2,3 | sort | cut -f2 | tail -n 1)
aws ec2 create-tags --resources ${TAGTHIS} --tags Key=Name,Value=${NAMETAGVALUE} Key=Ping,Value=Pong
echo -e "   Instance: \e[97m${TAGTHIS} \e[95mtagged as \e[34mName: \e[97m${NAMETAGVALUE}"
echo ""
echo -e "                           \e[95m*** \e[38;5;82mFINISHED \e[95m***"
for i in {16..50} {50..16} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
echo -e "\e[0m"

# ==========================================================
COUNTER.file
------------------------
spec.json
{
  "ImageId": "ami-0ce71448843cb18a1",
  "KeyName": "testKey",
  "SecurityGroupIds": [ "sg-0e5441aafb6d3deaf" ],
  "InstanceType": "t3.small",
  "SubnetId": "subnet-f853c09f",
  "IamInstanceProfile": {
      "Arn": "arn:aws:iam::295981215498:instance-profile/S3-Admin-Access"
  },
  "UserData": "IyEvYmluL2Jhc2gKeXVtIHVwZGF0ZSAteQplY2hvICJzZXQgYmFja2dyb3VuZD1kYXJrIiA+IC9ob21lL2VjMi11c2VyLy52aW1yYwplY2hvICJzZXQgdGFic3RvcD00IiA+PiAvaG9tZS9lYzItdXNlci8udmltcmMKZWNobyAic2V0IHNoaWZ0d2lkdGg9NCIgPj4gL2hvbWUvZWMyLXVzZXIvLnZpbXJjCmVjaG8gInNldCBleHBhbmR0YWIiID4+IC9ob21lL2VjMi11c2VyLy52aW1yYwplY2hvICJhbGlhcyB2aT0ndmltJyIgPj4gL2hvbWUvZWMyLXVzZXIvLmJhc2hyYwplY2hvICJzZXQgYmFja2dyb3VuZD1kYXJrIiA+PiAvcm9vdC8udmltcmMKZWNobyAiYWxpYXMgdmk9J3ZpbSciID4+IC9yb290Ly5iYXNocmM=",
  "BlockDeviceMappings": [
    {
      "DeviceName": "/dev/xvda",
      "VirtualName": "HereIsVirtualName",
      "Ebs": {
        "DeleteOnTermination": true,
        "VolumeSize": 8,
        "VolumeType": "gp2",
        "Encrypted": false
      },
  "NoDevice": ""
    }
  ]
}
