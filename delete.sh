#!/bin/bash
userid=$1
bucketname=$2
echo "Checking parameters..."

if [[ -z "$userid" ]]; then
    userid="$(aws sts get-caller-identity --query Account --output text)"
elif [[ ! "$userid" =~ ^[0-9]{12}$ ]]; then
    echo "Wrong format, -userid '[0-9]{12}' expected"
    exit 1
fi

if [[ -z "$bucketname" ]]; then
    echo "-bucketname expected, defaulting to athena-data-bucket"
    bucketname="athena-data-bucket"
fi

echo "Deleting CloudFormation stacks..."
aws cloudformation delete-stack --stack-name MonitoringInstance
aws cloudformation wait stack-delete-complete --stack-name MonitoringInstance

aws cloudformation delete-stack --stack-name Instances
aws cloudformation wait stack-delete-complete --stack-name Instances

aws cloudformation delete-stack --stack-name MasterBuild
aws cloudformation wait stack-delete-complete --stack-name MasterBuild

aws s3 rm s3://$bucketname-$userid --recursive
aws cloudformation delete-stack --stack-name S3Athena 
aws cloudformation delete-stack --stack-name ECR
aws cloudformation delete-stack --stack-name NAT
aws cloudformation delete-stack --stack-name EFS 
aws cloudformation delete-stack --stack-name RDS 

aws cloudformation wait stack-delete-complete --stack-name NAT
aws cloudformation wait stack-delete-complete --stack-name S3Athena
aws cloudformation wait stack-delete-complete --stack-name ECR
aws cloudformation wait stack-delete-complete --stack-name EFS
aws cloudformation wait stack-delete-complete --stack-name RDS

aws cloudformation delete-stack --stack-name MyBase
aws cloudformation wait stack-delete-complete --stack-name MyBase

printf "\a"