param($userid,$bucketname)
if (!$userid) {
    echo '-userid "[0-9]{12}" expected, not found'
    # $userid="089087866202"
    Break
} elseif (!($userid -match "[0-9]{12}")) {
    echo 'wrong format, -userid "[0-9]{12}" expected'
    Break
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
aws cloudformation delete-stack --stack-name RDS 

aws cloudformation wait stack-delete-complete --stack-name S3Athena
aws cloudformation wait stack-delete-complete --stack-name RDS
aws cloudformation wait stack-delete-complete --stack-name EFS

aws cloudformation delete-stack --stack-name MyBase
aws cloudformation wait stack-delete-complete --stack-name MyBase



[console]::beep(900, 1000)
