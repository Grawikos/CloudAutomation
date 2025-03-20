aws ssm start-session \
--target <instance_id> \
--document-name AWS-StartPortForwardingSession \
--parameters '{"portNumber":["5601"], "localPortNumber":["8080"]}'

aws ssm start-session --target <instance_id> --document-name AWS-StartPortForwardingSession --parameters '{\"portNumber\":[\"5601\"], \"localPortNumber\":[\"8080\"]}'