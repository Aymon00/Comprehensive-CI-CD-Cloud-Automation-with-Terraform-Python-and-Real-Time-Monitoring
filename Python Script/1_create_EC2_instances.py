import boto3
from pprint import pprint

'''Creating an instance using client object'''
session = boto3.session.Session(profile_name="ec2-dev")

ec2_cli = session.client(service_name="ec2", region_name="us-east-2")
my_instance = ec2_cli.run_instances(
    ImageId='ami-0b614a5d911900a9b',
    InstanceType='t2.micro',
    KeyName='awsec2key',
    MaxCount=1,
    MinCount=1)
print("my instance created successfully")
pprint(my_instance)
