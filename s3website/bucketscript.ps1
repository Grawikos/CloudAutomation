param($userid,$bucketname)
if (!$userid) {
    echo "-userid expected"
    # -userid "089087866202"
    Break
} 
if (!$bucketname) {
    echo "-bucketname expected, defaulting to athena-data-bucket"
    $bucketname="athena-data-bucket"
} 

aws s3api put-bucket-website --bucket $bucketname-$userid --website-configuration file://website.json
aws s3api put-public-access-block --bucket $bucketname-$userid --public-access-block-configuration "BlockPublicAcls=false"
aws s3api put-bucket-ownership-controls --bucket $bucketname-$userid --ownership-controls="Rules=[{ObjectOwnership=ObjectWriter}]"
aws s3api put-bucket-policy --bucket $bucketname-$userid --policy file://policy.json
aws s3 cp s3://athena-data-bucket-089087866202/out.txt s3://athena-data-bucket-089087866202/tmp.txt
aws s3 rm s3://athena-data-bucket-089087866202/tmp.txt

echo Website:
echo "http://$bucketname-$userid.s3-website-us-east-1.amazonaws.com/"