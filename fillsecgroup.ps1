param($ip1,$ip2,$ip3)

$SECURITY_GROUP_ID = aws ec2 describe-security-groups --filters "Name=tag:Name,Values=RDSSG"  --query 'SecurityGroups[0].GroupId' --output text
aws ec2 authorize-security-group-ingress  --group-id "$SECURITY_GROUP_ID" --protocol "tcp" --port "1433" --cidr "$ip1"
aws ec2 authorize-security-group-ingress  --group-id "$SECURITY_GROUP_ID" --protocol "tcp" --port "1433" --cidr "$ip2"
aws ec2 authorize-security-group-ingress  --group-id "$SECURITY_GROUP_ID" --protocol "tcp" --port "1433" --cidr "$ip3"
