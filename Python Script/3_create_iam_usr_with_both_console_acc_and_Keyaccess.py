import boto3
from random import choice
import sys

aws_session = boto3.session.Session(profile_name="iam-dev", region_name='us-east-2')
usr_client = aws_session.client(service_name='iam', region_name='us-east-2')

random_chars = "asdfghjklmnbvcxzqwertyuioASDFGHJKLMNBVCXZQWERTYUIO1234567890-=][\\';.?/"
len_of_pass = 8
password = "".join(choice(random_chars) for char in range(len_of_pass))

username = "AWS_console_cli_Full"
usr_client.create_user(UserName=username)
usr_client.create_login_profile(UserName=username, Password=password, PasswordResetRequired=False)
usr_access_key = usr_client.create_access_key(UserName=username)
usr_client.attach_user_policy(UserName=username, PolicyArn='arn:aws:iam::aws:policy/AdministratorAccess')
print(f"successfully created username :{username} with Password:{password}")
print(f"successfully created username :{username}"
      f"with Access-key_ID:{usr_access_key['AccessKey']['AccessKeyId']}"
      f"with Secret_Key: {usr_access_key['AccessKey']['SecretAccessKey']}")
