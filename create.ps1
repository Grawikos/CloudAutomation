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

aws ssm put-parameter --name "/gcp/service-account/json" --type "SecureString" --value file://gcp-service-account.json



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