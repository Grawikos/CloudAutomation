param($instanceid)
if (!$instanceid){
    echo "expected -instanceid, not found"
    Break
}

aws ssm start-session --target $instanceid --document-name AWS-StartPortForwardingSession --parameters '{\"portNumber\":[\"5601\"], \"localPortNumber\":[\"8080\"]}'
echo "Website:"
echo "http://localhost:8080"