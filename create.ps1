param($userid,$bucketname)
if (!$userid) {
    $userid="$(aws sts get-caller-identity --query Account --output text)"
} elseif (!($userid -match "[0-9]{12}")) {
    echo 'wrong format, -userid "[0-9]{12}" expected'
    Break
}

if (!$bucketname) {
    echo "-bucketname expected, defaulting to athena-data-bucket"
    $bucketname="athena-data-bucket"
} 

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
while ($($(aws ecr list-images --repository-name appimagerepository --query 'imageIds') -eq "[]")){
    # echo "no image yet"
    Start-Sleep -Seconds 5
}
aws cloudformation create-stack --stack-name Instances --template-body file://templates/instances.yml
aws cloudformation wait stack-create-complete --stack-name Instances


aws cloudformation create-stack --stack-name MonitoringInstance --template-body file://templates/monitoringInstance.yml
aws cloudformation wait stack-create-complete --stack-name MonitoringInstance


echo "Link to the website:"
echo "http://$(aws cloudformation describe-stacks --stack-name Instances --query 'Stacks[0].Outputs[?OutputKey==`LoadBalancerDNS`].OutputValue' --output text)"

[console]::beep(300, 1000)