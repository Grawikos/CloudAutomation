#!/bin/bash
ip1=$1
ip2=$2
ip3=$3

SECURITY_GROUP_ID=$(aws ec2 describe-security-groups --filters Name=tag:Name,Values=RDSSG --query 'SecurityGroups[0].GroupId' --output text)

# Check if the security group ID was retrieved
if [ -z "$SECURITY_GROUP_ID" ]; then
  echo "Security Group not found"
  exit 1
fi

aws ec2 authorize-security-group-ingress --group-id "$SECURITY_GROUP_ID" --protocol tcp --port 1433 --cidr "$ip1"
aws ec2 authorize-security-group-ingress --group-id "$SECURITY_GROUP_ID" --protocol tcp --port 1433 --cidr "$ip2"
aws ec2 authorize-security-group-ingress --group-id "$SECURITY_GROUP_ID" --protocol tcp --port 1433 --cidr "$ip3"