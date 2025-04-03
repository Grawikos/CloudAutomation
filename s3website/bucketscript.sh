#!/bin/bash

userid="$1"
bucketname="$2"
region="$3"

if [ -z "$userid" ]; then
    userid=$(aws sts get-caller-identity --query Account --output text)
fi

if [ -z "$bucketname" ]; then
    echo "-bucketname expected, defaulting to athena-data-bucket"
    bucketname="athena-data-bucket"
fi

if [ -z "$region" ]; then
    region="us-east-1"
fi

policy=$(cat <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "PublicReadGetObject",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::$bucketname-$userid/*"
        }
    ]
}
EOF
)


aws s3api put-bucket-website --bucket "$bucketname-$userid" --website-configuration file://website.json
aws s3api put-public-access-block --bucket "$bucketname-$userid" --public-access-block-configuration '{"BlockPublicAcls":false}'
aws s3api put-bucket-ownership-controls --bucket "$bucketname-$userid" --ownership-controls 'Rules=[{ObjectOwnership=ObjectWriter}]'
aws s3api put-bucket-policy --bucket "$bucketname-$userid" --policy "$policy"

aws s3 cp "s3://$bucketname-$userid/out.txt" "s3://$bucketname-$userid/tmp.txt"
aws s3 rm "s3://$bucketname-$userid/tmp.txt"

echo "Website:"
echo "http://$bucketname-$userid.s3-website-$region.amazonaws.com/"
