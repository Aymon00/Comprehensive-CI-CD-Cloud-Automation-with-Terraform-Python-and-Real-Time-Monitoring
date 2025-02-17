import boto3
from pprint import pprint

'''create new bucket using client object'''
session = boto3.session.Session(profile_name='s3-dev')
s3_cli = session.client(service_name='s3', region_name='us-east-2')
bucket_name = 'dolfinedbucket12345'
# new_bucket = s3_cli.create_bucket(Bucket=bucket_name,CreateBucketConfiguration={'LocationConstraint': 'us-east-2'})
# pprint(new_bucket)

'''delete  bucket using client object'''
response = s3_cli.delete_bucket(Bucket=bucket_name)
print("successfully deleted the bucket")
