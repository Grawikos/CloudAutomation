param($userid)
if (!$userid) {
    echo "-userid expected, defaulting to 089087866202"
    $userid="089087866202"
} 

aws cloudformation create-stack --stack-name MyBase --template-body file://networking.yml
aws cloudformation wait stack-create-complete --stack-name MyBase

aws cloudformation create-stack --stack-name EFS --template-body file://efs.yml
aws cloudformation create-stack --stack-name SSMS --template-body file://ssms.yml
aws cloudformation create-stack --stack-name S3Athena --template-body file://bucket.yml --parameters ParameterKey=LabAccountID,ParameterValue=$userid


aws cloudformation wait stack-create-complete --stack-name EFS
aws cloudformation wait stack-create-complete --stack-name SSMS
aws cloudformation wait stack-create-complete --stack-name S3Athena

aws cloudformation create-stack --stack-name Instances --template-body file://instances.yml
aws cloudformation wait stack-create-complete --stack-name Instances

echo "Link to the website:"
echo "http://$(aws cloudformation describe-stacks --stack-name Instances --query 'Stacks[0].Outputs[?OutputKey==`LoadBalancerDNS`].OutputValue' --output text)"

[console]::beep(300, 1000)