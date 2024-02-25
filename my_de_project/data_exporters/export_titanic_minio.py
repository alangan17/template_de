from mage_ai.settings.repo import get_repo_path
from mage_ai.io.config import ConfigFileLoader
from mage_ai.io.s3 import S3
from pandas import DataFrame
from os import path
from minio import Minio

if 'data_exporter' not in globals():
    from mage_ai.data_preparation.decorators import data_exporter


@data_exporter
def export_data_to_minio(df: DataFrame, **kwargs) -> None:
    """
    Upload file to minio.
    Prerequisites:
    1. Spin up Mino Server
    2. Login to Minio Server
    3. Create access key (i.e. service account of the user logged in)
    4. Save the
    Ref: https://min.io/docs/minio/linux/developers/python/minio-py.html
    """
    config_path = path.join(get_repo_path(), 'io_config.yaml')
    config_profile = 'default'

    bucket_name = 'test5'

    # The file to upload, change this path if needed
    df.to_csv("titanic_clean.csv")
    source_file = "titanic_clean.csv"
    destination_file = "my_titanic_clean.csv"

    # Create client with access key and secret key with specific region.
    client = Minio(
        endpoint=ConfigFileLoader(config_path, config_profile).get("MINIO_ENDPOINT"),
        access_key=ConfigFileLoader(config_path, config_profile).get("MINIO_ACCESS_KEY"),
        secret_key=ConfigFileLoader(config_path, config_profile).get("MINIO_SECRET_KEY"),
        region=ConfigFileLoader(config_path, config_profile).get("MINIO_REGION"),
        secure=False
    )

    # Make the bucket if it doesn't exist.
    found = client.bucket_exists(bucket_name)
    if not found:
        client.make_bucket(bucket_name)
        print("Created bucket", bucket_name)
    else:
        print("Bucket", bucket_name, "already exists")

    # Upload the file, renaming it in the process
    client.fput_object(
        bucket_name, destination_file, source_file,
    )
    print(
        source_file, "successfully uploaded as object",
        destination_file, "to bucket", bucket_name,
    )