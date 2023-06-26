import boto3
import json
import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb =  boto3.resource('dynamodb', region_name="us-east-1")
s3_client = boto3.client('s3', region_name="us-east-1", endpoint_url=f"http://{os.environ.get('LOCALSTACK_HOSTNAME','')}:4566")




def process_new_users(event, _):
    if "Records" not in event:
        logger.error("No 'Records' found in event")
        raise ValueError(("Event does not have key named 'Records'"))
    
    for record in event["Records"]:
        bucket = record["s3"]["bucket"]["name"]
        s3_file_key = record["s3"]["object"]["key"]
        logger.info(f"bucket: {bucket} key: {s3_file_key}")
        user_file = s3_client.get_object(Bucket=bucket, Key=s3_file_key)
        logger.info(f"Got file: {user_file}")
        users = json.loads(user_file["Body"].read())
        logger.info(f"Loaded file: {user_file}")
        for user in users:
            logger.info(user)

    
