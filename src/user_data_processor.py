import boto3
import json
import logging
import os
import uuid

logger = logging.getLogger()
logger.setLevel(logging.INFO)

dynamodb =  boto3.resource('dynamodb', region_name="us-east-1")
s3_client = boto3.client('s3', region_name="us-east-1", endpoint_url=f"http://{os.environ.get('LOCALSTACK_HOSTNAME','')}:4566")




def process_new_users(event, _):
    if "Records" not in event:
        logger.error("No 'Records' found in event")
        raise ValueError(("Event does not have key named 'Records'"))
    
    users_to_write = []
    cars_to_write = []

    for record in event["Records"]:
        bucket = record["s3"]["bucket"]["name"]
        s3_file_key = record["s3"]["object"]["key"]
        logger.info(f"bucket: {bucket} key: {s3_file_key}")
        user_file = s3_client.get_object(Bucket=bucket, Key=s3_file_key)
        logger.info(f"Got file: {user_file}")
        users = json.loads(user_file["Body"].read())
        logger.info(f"Loaded file: {user_file}")
        for user in users:
            car = user["car"]
            car_uuid = str(uuid.uuid4())
            user["car"] = car_uuid
            car["id"] = car_uuid
            logger.info(car)
            logger.info(user)
            users_to_write.append(user)
            cars_to_write.append(car)

    logger.info(users_to_write)
    logger.info(cars_to_write)

    user_table = dynamodb.Table(os.environ.get("user_db_name"))
    car_table = dynamodb.Table(os.environ.get("car_db_name"))
    
    with user_table.batch_writer() as user_writer:
        with car_table.batch_writer() as car_writer:
            for user in users_to_write:
                user_writer.put_item(user)
            for car in cars_to_write:
                car_writer.put_item(car)
    
