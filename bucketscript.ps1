param($userid)
if (!$userid) {
    echo "-userid expected, defaulting to 089087866202"
    $userid="089087866202"
} 
aws s3api put-object --bucket athena-data-bucket-$userid --key index.html --body index.html
aws s3api put-bucket-website --bucket athena-data-bucket-$userid --website-configuration file://website.json
aws s3api put-public-access-block --bucket athena-data-bucket-$userid --public-access-block-configuration "BlockPublicAcls=false"
aws s3api put-bucket-ownership-controls --bucket athena-data-bucket-$userid --ownership-controls="Rules=[{ObjectOwnership=ObjectWriter}]"
aws s3api put-object-acl --bucket athena-data-bucket-$userid --key index.html --acl public-read
aws s3api put-bucket-policy --bucket athena-data-bucket-$userid --policy file://policy.json
aws s3 cp index.html s3://athena-data-bucket-$userid/ --acl public-read --content-type "text/html"