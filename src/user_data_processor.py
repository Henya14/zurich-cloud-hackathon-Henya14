import boto3
import json
import logging
import os
import uuid

logger = logging.getLogger()
logger.setLevel(logging.INFO)

endpoint_url = f"http://{os.environ.get('LOCALSTACK_HOSTNAME')}:{os.environ.get('EDGE_PORT')}" if os.environ.get('LOCALSTACK_HOSTNAME', None) else None
dynamodb =  boto3.resource('dynamodb', region_name=os.environ.get('AWS_REGION'), endpoint_url=endpoint_url)
s3_client = boto3.client('s3', region_name=os.environ.get('AWS_REGION'), endpoint_url=endpoint_url)

def process_new_users(event, _):
    users_to_write_to_db = []
    cars_to_write_to_db = []

    logger.info(f"Collecting data to write into database")
    for record in event["Records"]:
        users = get_users_from_record(record)
        for user in users:
            car, user = create_car_and_user_db_items(user)
            users_to_write_to_db.append(user)
            cars_to_write_to_db.append(car)
    logger.info(f"Data collection complete")

    try:
        logger.info(f"Staring database write")
        write_users_and_cars_to_db(users_to_write_to_db, cars_to_write_to_db)
        logger.info(f"Database write successful")
    except Exception as err:
        logger.error(f"Couldn't save data to database. Error: {err}", )
        raise

def get_users_from_record(record):
    bucket = record["s3"]["bucket"]["name"]
    s3_file_key = record["s3"]["object"]["key"]
    logger.info(f"bucket: {bucket} key: {s3_file_key}")
    user_file = s3_client.get_object(Bucket=bucket, Key=s3_file_key)
    users = json.loads(user_file["Body"].read())
    return users

def create_car_and_user_db_items(user):
    car = user["car"]
    car_uuid = str(uuid.uuid4())
    user["car"] = car_uuid
    car["id"] = car_uuid
    return car, user
    
def write_users_and_cars_to_db(users_to_write, cars_to_write):
    user_table = dynamodb.Table(os.environ.get("user_db_name"))
    car_table = dynamodb.Table(os.environ.get("car_db_name"))
    
    with user_table.batch_writer() as user_writer:
        with car_table.batch_writer() as car_writer:
            for user in users_to_write:
                user_writer.put_item(Item=user)
            for car in cars_to_write:
                car_writer.put_item(Item=car)
