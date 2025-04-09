userid=$(aws sts get-caller-identity --query "Account" --output text)

aws s3 rm s3://athena-data-bucket-$userid --recursive
aws ecr delete-repository --repository-name appimagerepository --force

terraform destroy -auto-approve
