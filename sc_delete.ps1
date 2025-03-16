aws cloudformation delete-stack --stack-name Instances
aws cloudformation wait stack-delete-complete --stack-name Instances

aws cloudformation delete-stack --stack-name SSMS
aws cloudformation wait stack-delete-complete --stack-name SSMS


aws cloudformation delete-stack --stack-name EFS
aws cloudformation wait stack-delete-complete --stack-name EFS

aws cloudformation delete-stack --stack-name Networking
aws cloudformation wait stack-delete-complete --stack-name Networking



[console]::beep(900, 1000)
