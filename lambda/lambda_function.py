import requests
import boto3
import os
from datetime import datetime

# URLs of datasets
urls = {
    "Study_citizenship": "https://www.ircc.canada.ca/opendata-donneesouvertes/data/ODP-TR-Study-IS_CITZ.csv",
    "Study_province_level": "https://www.ircc.canada.ca/opendata-donneesouvertes/data/ODP-TR-Study-IS_PT_study.csv",
    "Study_province_gender": "https://www.ircc.canada.ca/opendata-donneesouvertes/data/ODP-TR-Study-IS_PT_gender.csv"
}

s3_client = boto3.client('s3')
bucket_name = os.environ['BUCKET_NAME']

def download_file(url):
    response = requests.get(url)
    response.raise_for_status()
    return response.content

def lambda_handler(event, context):
    # Get the current date in YYYY-MM-DD format
    current_date = datetime.now().strftime("%Y-%m-%d")
    
    for name, url in urls.items():
        # Download the file
        data = download_file(url)
        
        # Set S3 key with "downloaded_files/" prefix and current date
        s3_key = f"downloaded_files/{name}_{current_date}.csv"
        
        # Upload the file to S3 with the specified prefix
        s3_client.put_object(Bucket=bucket_name, Key=s3_key, Body=data)
        print(f"Uploaded {s3_key} to S3 bucket {bucket_name}")


# Package the Lambda Code (for Upload)
# pip install requests -t .