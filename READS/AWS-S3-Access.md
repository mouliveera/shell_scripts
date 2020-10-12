## AWS S3 Access

#### Install

`MacOS:` brew install awscli

Check the aws version is installed or not by the following command
```shell
aws --version
```


Enter your Access key ID and Secret Access Key in AWS Config file.
Try
```
❯ aws configure
```

You can use default for region and output format

(or)
```
❯ vi ~/.aws/config
```
Use below lines as reference and adjust aws_access_key_id and aws_secret_access_key values.
```
##############
# Apple
##############
[profile apple]
aws_access_key_id = <aws_access_key_id>
aws_secret_access_key = <aws_secret_access_key>
region = us-east-1
```

##### List s3 bucket using awscli
```shell
❯ aws s3 ls s3://vendor-deliveries/reputation.com/ --profile apple
```

##### Copy files
```shell
❯ aws s3 cp <DIR>/<files> s3://vendor-deliveries/reputation.com/ --profile apple
```
