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

echo "Creating CloudFormation stacks..."
aws cloudformation create-stack --stack-name MyBase --template-body file://templates/networking.yml
aws cloudformation wait stack-create-complete --stack-name MyBase

aws cloudformation create-stack --stack-name RDS --template-body file://templates/rds.yml
aws cloudformation create-stack --stack-name NAT --template-body file://templates/nat.yml
aws cloudformation create-stack --stack-name EFS --template-body file://templates/efs.yml
aws cloudformation create-stack --stack-name S3Athena --template-body file://templates/bucket.yml --parameters ParameterKey=LabAccountID,ParameterValue=$userid ParameterKey=BucketName,ParameterValue=$bucketname
aws cloudformation create-stack --stack-name ECR --template-body file://templates/ecr.yml

aws cloudformation wait stack-create-complete --stack-name ECR
aws cloudformation wait stack-create-complete --stack-name EFS
aws cloudformation wait stack-create-complete --stack-name S3Athena
aws cloudformation wait stack-create-complete --stack-name NAT
aws cloudformation wait stack-create-complete --stack-name RDS

aws cloudformation create-stack --stack-name MasterBuild --template-body file://templates/buildMaster.yml
aws cloudformation wait stack-create-complete --stack-name MasterBuild

aws cloudformation create-stack --stack-name Instances --template-body file://templates/instances.yml
aws cloudformation wait stack-create-complete --stack-name Instances

aws cloudformation create-stack --stack-name MonitoringInstance --template-body file://templates/monitoringInstance.yml
aws cloudformation wait stack-create-complete --stack-name MonitoringInstance

echo "Link to the website:"
echo "http://$(aws cloudformation describe-stacks --stack-name Instances --query 'Stacks[0].Outputs[?OutputKey==\`LoadBalancerDNS\`].OutputValue' --output text)"

printf "\a"