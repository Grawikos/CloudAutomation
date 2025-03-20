param($userid,$bucketname)
if (!$userid) {
    echo "-userid expected, defaulting to 089087866202"
    $userid="089087866202"
} 
if (!$bucketname) {
    echo "-bucketname expected, defaulting to athena-data-bucket"
    $bucketname="athena-data-bucket"
} 

aws s3api put-object --bucket $bucketname-$userid --key index.html --body index.html
aws s3api put-bucket-website --bucket $bucketname-$userid --website-configuration file://website.json
aws s3api put-public-access-block --bucket $bucketname-$userid --public-access-block-configuration "BlockPublicAcls=false"
aws s3api put-bucket-ownership-controls --bucket $bucketname-$userid --ownership-controls="Rules=[{ObjectOwnership=ObjectWriter}]"
aws s3api put-object-acl --bucket $bucketname-$userid --key index.html --acl public-read
aws s3api put-bucket-policy --bucket $bucketname-$userid --policy file://policy.json
aws s3 cp index.html s3://$bucketname-$userid/ --acl public-read --content-type "text/html"
echo Website:
echo "http://$bucketname-$userid.s3-website-us-east-1.amazonaws.com/"