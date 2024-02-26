# Template for Data Engineering

## Features - Dcoker Compose Services
1. Notebook like python/ SQL/ R development & orchestration environment by [Mage](mage.ai)
   
   Optional features to opt in when building the Docker image (see [Dockerfile](/devops/mage/Dockerfile)):
   1. Microsoft SQL Server ODBC Driver 17/ 18
   2. Microsoft Active Directory Authentication via Kerberos
   3. AzCopy (For file between Local Storage and Azure Blob Storage)
   4. DuckDB CLI (In memory SQL database)

2. MinIO - optional service to spin up

## Setup
1. Prepare config files and create directories:
```bash
bash script/00_repo_initial_setup.sh
```

2. Start the docker containers:
```bash
docker-compose up -d
```