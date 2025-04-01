#!/bin/bash
userid=$1
bucketname=$2
echo "Checking parameters..."

if [[ -z "$userid" ]]; then
    echo "-userid '[0-9]{12}' expected, not found"
    exit 1
elif [[ ! "$userid" =~ ^[0-9]{12}$ ]]; then
    echo "Wrong format, -userid '[0-9]{12}' expected"
    exit 1
fi

if [[ -z "$bucketname" ]]; then
    echo "-bucketname expected, defaulting to athena-data-bucket"
    bucketname="athena-data-bucket"
fi

echo "Creating CloudFormation stacks..."
aws cloudformation create-stack --stack-name MyBase --template-body file://networking.yml
aws cloudformation wait stack-create-complete --stack-name MyBase

aws cloudformation create-stack --stack-name RDS --template-body file://rds.yml
aws cloudformation create-stack --stack-name NAT --template-body file://nat.yml
aws cloudformation create-stack --stack-name EFS --template-body file://efs.yml
aws cloudformation create-stack --stack-name S3Athena --template-body file://bucket.yml --parameters ParameterKey=LabAccountID,ParameterValue=$userid ParameterKey=BucketName,ParameterValue=$bucketname

aws cloudformation wait stack-create-complete --stack-name EFS
aws cloudformation wait stack-create-complete --stack-name S3Athena
aws cloudformation wait stack-create-complete --stack-name NAT
aws cloudformation wait stack-create-complete --stack-name RDS

aws cloudformation create-stack --stack-name Instances --template-body file://instances.yml
aws cloudformation wait stack-create-complete --stack-name Instances

aws cloudformation create-stack --stack-name MonitoringInstance --template-body file://monitoringInstance.yml
aws cloudformation wait stack-create-complete --stack-name MonitoringInstance

echo "Link to the website:"
echo "http://$(aws cloudformation describe-stacks --stack-name Instances --query 'Stacks[0].Outputs[?OutputKey==\`LoadBalancerDNS\`].OutputValue' --output text)"

printf "\a"