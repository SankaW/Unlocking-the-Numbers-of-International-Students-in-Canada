import boto3
import os
import pandas as pd
import io

s3_client = boto3.client('s3')
bucket_name = os.environ['BUCKET_NAME']

# S3 Prefixes
download_prefix = "downloaded_files/"
cleaned_prefix = "cleaned_files/"

# Function to clean CSV data
def clean_csv_file(data, file_name):

    # Check if data is empty or has only whitespace
    if not data.strip():
        print(f"File {file_name} is empty or has no data to parse.")
        return

    # Try reading the CSV data into a DataFrame
    try:
        df = pd.read_csv(io.StringIO(data), delimiter='\t')
    except pd.errors.EmptyDataError:
        print(f"File {file_name} could not be parsed. Skipping file.")
        return

    # Proceed with data processing if the DataFrame has data
    if df.empty:
        print(f"File {file_name} has no content after parsing. Skipping.")
        return

    # # Load the CSV data into a Pandas DataFrame
    # df = pd.read_csv(io.StringIO(data), delimiter='\t')

    # Replace "--" with NaN only in the 'TOTAL' column
    if 'TOTAL' in df.columns:
        df['TOTAL'] = df['TOTAL'].replace('--', pd.NA)

    # Drop columns with French names that start with "FR_"
    columns_to_keep = [column for column in df.columns if not column.startswith('FR_')]
    filtered_df = df[columns_to_keep]

    # Remove "EN_" from each column name
    filtered_df.columns = [col.replace('EN_', '') for col in filtered_df.columns]

    # Save the cleaned DataFrame to a CSV in memory
    output = io.StringIO()
    filtered_df.to_csv(output, index=False)
    output.seek(0)  # Move to the start of the StringIO object

    # Upload the cleaned data to S3 under the cleaned_files/ prefix
    cleaned_key = f"{cleaned_prefix}{file_name}"
    s3_client.put_object(Bucket=bucket_name, Key=cleaned_key, Body=output.getvalue())
    print(f"Cleaned data saved to {cleaned_key} in S3 bucket {bucket_name}")

# Lambda handler function
def lambda_handler(event, context):
    # List objects with the downloaded_files/ prefix
    response = s3_client.list_objects_v2(Bucket=bucket_name, Prefix=download_prefix)
    
    # Check if there are any files to process
    if 'Contents' in response:
        for obj in response['Contents']:
            file_name = obj['Key'].split('/')[-1]  # Get the file name from the key

            # Download the file content
            response = s3_client.get_object(Bucket=bucket_name, Key=obj['Key'])
            data = response['Body'].read().decode('utf-8')

            # Clean and save the file
            clean_csv_file(data, file_name)
    else:
        print("No files found in downloaded_files/ prefix.")

