param($userid,$bucketname)
if (!$userid) {
    echo "-userid expected, defaulting to 089087866202"
    $userid="089087866202"
} 
if (!$bucketname) {
    echo "-bucketname expected, defaulting to athena-data-bucket"
    $bucketname="athena-data-bucket"
} 

aws cloudformation delete-stack --stack-name MonitoringInstance
aws cloudformation wait stack-delete-complete --stack-name MonitoringInstance

aws cloudformation delete-stack --stack-name NAT
aws cloudformation wait stack-delete-complete --stack-name NAT

aws cloudformation delete-stack --stack-name Instances
aws cloudformation wait stack-delete-complete --stack-name Instances

aws s3 rm s3://$bucketname-$userid --recursive
aws cloudformation delete-stack --stack-name S3Athena 
aws cloudformation delete-stack --stack-name EFS 
aws cloudformation delete-stack --stack-name SSMS 

aws cloudformation wait stack-delete-complete --stack-name S3Athena
aws cloudformation wait stack-delete-complete --stack-name SSMS
aws cloudformation wait stack-delete-complete --stack-name EFS

aws cloudformation delete-stack --stack-name MyBase
aws cloudformation wait stack-delete-complete --stack-name MyBase



[console]::beep(900, 1000)
