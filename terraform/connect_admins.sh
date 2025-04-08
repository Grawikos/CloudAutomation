instanceid=$(aws ec2 describe-instances \
  --filters "Name=tag:Name,Values=MonitoringInstance" \
  --query 'Reservations[0].Instances[0].InstanceId' \
  --output text)

aws ssm start-session \
  --target "$instanceid" \
  --document-name AWS-StartPortForwardingSession \
  --parameters '{"portNumber":["5601"], "localPortNumber":["8080"]}'