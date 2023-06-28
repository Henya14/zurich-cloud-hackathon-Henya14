import boto3
import json
import logging
import os

logger = logging.getLogger()
logger.setLevel(logging.INFO)

endpoint_url = f"http://{os.environ.get('LOCALSTACK_HOSTNAME')}:{os.environ.get('EDGE_PORT')}" if os.environ.get('LOCALSTACK_HOSTNAME', None) else None
dynamodb =  boto3.resource('dynamodb', region_name=os.environ.get('AWS_REGION'), endpoint_url=endpoint_url)
s3_client = boto3.client('s3', region_name=os.environ.get('AWS_REGION'), endpoint_url=endpoint_url)

def process_new_users(event, _):
    users_to_write_to_db = []

    logger.info(f"Collecting data to write into database")
    for record in event["Records"]:
        users = get_users_from_record(record)
        for user in users:
            user = transform_user_to_db_user(user)
            users_to_write_to_db.append(user)
    logger.info(f"Data collection complete")

    try:
        logger.info(f"Starting database write {users_to_write_to_db}")
        write_data_to_db(data_list=users_to_write_to_db, db_name=os.environ.get("USER_DB_NAME"))
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

def transform_user_to_db_user(user: dict):
    car = user["car"]
    for key in car:
        user[f"car.{key}"] = car[key]
        
    user.pop("car")
    return user
    
def write_data_to_db(data_list, db_name):
    user_table = dynamodb.Table(db_name)
    
    with user_table.batch_writer() as user_batch_writer:
        for data in data_list:
            user_batch_writer.put_item(Item=data)