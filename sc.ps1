aws cloudformation create-stack --stack-name Networking --template-body file://networking.yml
aws cloudformation wait stack-create-complete --stack-name Networking

aws cloudformation create-stack --stack-name EFS --template-body file://efs.yml
aws cloudformation create-stack --stack-name SSMS --template-body file://ssms.yml
aws cloudformation create-stack --stack-name S3Athena --template-body file://bucket.yml --parameters ParameterKey=LabAccountID,ParameterValue=089087866202


aws cloudformation wait stack-create-complete --stack-name EFS
aws cloudformation wait stack-create-complete --stack-name SSMS
aws cloudformation wait stack-create-complete --stack-name S3Athena

aws cloudformation create-stack --stack-name Instances --template-body file://instances.yml
aws cloudformation wait stack-create-complete --stack-name Instances

[console]::beep(300, 1000)