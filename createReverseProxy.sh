GCEALB=$1
aws cloudformation create-stack --stack-name ReverseProxy --template-body file://infrastracture/AWS_CF_Templates/ReverseProxy.yml --parameters ParameterKey=GCEALB,ParameterValue=$GCEALB
aws cloudformation wait stack-create-complete --stack-name ReverseProxy

echo "Link to the website:"
echo "http://$(aws cloudformation describe-stacks --stack-name ReverseProxy --query 'Stacks[0].Outputs[?OutputKey==`ProxyInstancePublicIP`].OutputValue' --output text)"
