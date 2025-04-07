param($port)
if (!$port){
    $port=8080
}
$params = '{\"portNumber\":[\"5601\"], \"localPortNumber\":[\"' + $port + '\"]}'
echo "Website:"
echo http://localhost:$port

$instanceid=$( aws ec2 describe-instances --filters "Name=tag:Name,Values=MonitoringInstance" --query 'Reservations[0].Instances[0].InstanceId' )
aws ssm start-session --target $instanceid --document-name AWS-StartPortForwardingSession --parameters $params

