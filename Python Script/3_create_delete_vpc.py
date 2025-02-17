import boto3
from pprint import pprint

'''Creating a VPC using Client Object'''
session = boto3.session.Session(profile_name="ec2-dev")
ec2_cli = session.client(service_name="ec2", region_name="us-east-2")
# new_vpc = ec2_cli.create_vpc(CidrBlock='10.0.0.0/16')
# print("the new vpc has been created successfully")
# pprint(new_vpc)

'''list the existing VPC details'''
existing_VPCs = ec2_cli.describe_vpcs()['Vpcs']
# # pprint(existing_VPCs)
for vpc in existing_VPCs:
    print(vpc['CidrBlock'], vpc['VpcId'], vpc['State'])

'''delete an existing VPC'''
# vpc_to_delete = 'vpc-0959a71a776ab9bb7'
# deleted_vpc = ec2_cli.delete_vpc(VpcId=vpc_to_delete)
# print(f"vpc:{vpc_to_delete} has been deleted successfully")
# print(deleted_vpc)
