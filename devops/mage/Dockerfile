FROM mageai/mageai:0.9.64
## Available version: https://hub.docker.com/r/mageai/mageai/tags

## What is inside the image:
## 1. Base image from Mage
## Comment out the following sections if you don't need them
## 2. ODBC drivers for SQL Server
## 3. Kerberos Client for Windows Active Directory Authentication
## 4. DuckDB CLI
## 5. AzCopy (For file between Local Storage and Azure Blob Storage)

ENV DEBIAN_FRONTEND=noninteractive

ARG PROJECT_NAME=mage
ARG MAGE_CODE_PATH=.
ARG PIPENVFILE
ARG TARGETPLATFORM
ARG BUILDPLATFORM
RUN echo "Building image for $TARGETPLATFORM, performed by $BUILDPLATFORM"

WORKDIR ${MAGE_CODE_PATH}

## Update apt-get
RUN apt-get update

## 2. ODBC drivers for SQL Server
## msodbcsql17 is not supported for ARM64 architecture (e.g. Mac M1)
## For X86_64 (e.g. Windows, Mac Intel)
# RUN if [ "$TARGETPLATFORM" = "linux/amd64" ] \
#     ; then ACCEPT_EULA=Y apt-get install -y --allow-unauthenticated msodbcsql17 \
#     ; fi
# RUN ACCEPT_EULA=Y apt-get install -y --allow-unauthenticated msodbcsql18

## 3. Kerberos Client for Windows Active Directory Authentication
# RUN ACCEPT_EULA=Y apt-get install -y --no-install-recommends \
#     krb5-user \
#     cron

## 4. DuckDB CLI
## Ref: https://duckdb.org/docs/installation/index
## Ref: https://docs.bacalhau.org/examples/data-engineering/DuckDB/#containerize-script-using-docker
## For X86_64 (e.g. Windows, Mac Intel)
RUN if [ "$TARGETPLATFORM" = "linux/amd64" ] \
    ; then bash -c 'wget https://github.com/duckdb/duckdb/releases/download/v0.10.0/duckdb_cli-linux-amd64.zip; unzip duckdb_cli-linux-amd64.zip -d /usr/local/bin; rm duckdb_cli-linux-amd64.zip' \
    ; fi

## For ARM64 (e.g. Mac M1/M2)
RUN if [ "$TARGETPLATFORM" = "linux/arm64" ] \
    ; then bash -c 'wget https://github.com/duckdb/duckdb/releases/download/v0.10.0/duckdb_cli-linux-aarch64.zip; unzip duckdb_cli-linux-aarch64.zip -d /usr/local/bin; rm duckdb_cli-linux-aarch64.zip' \
    ; fi

## 5. AzCopy (For file between Local Storage and Azure Blob Storage)
## How to install in docker: https://gist.github.com/aessing/76f1200c9f5b2b9671937b3b0ed5fd6f?permalink_comment_id=4446191#gistcomment-4446191
## Available version: https://learn.microsoft.com/en-us/azure/storage/common/storage-use-azcopy-v10#download-azcopy
## For X86_64 (e.g. Windows, Mac Intel)
# RUN if [ "$TARGETPLATFORM" = "linux/amd64" ] \
#     ; then bash -c 'cd /usr/local/bin; curl -L https://aka.ms/downloadazcopy-v10-linux | tar --strip-components=1 --exclude=*.txt -xzvf -; chmod +x azcopy' \
#     ; fi
## For ARM64 (e.g. Mac M1/M2)
# RUN if [ "$TARGETPLATFORM" = "linux/arm64" ] \
#     ; then bash -c 'cd /usr/local/bin; curl -L https://aka.ms/downloadazcopy-v10-linux-arm64 | tar --strip-components=1 --exclude=*.txt -xzvf -; chmod +x azcopy' \
#     ; fi

## copy scripts folder
COPY --chown=root:root scripts/* /opt/init_scripts/

## set the working directory
WORKDIR /opt/init_scripts

## 2. ODBC drivers for SQL Server
## To resolve the connectivity issue to SQL Server - TCP Provider: Error code 0x2746
## Ref1: https://github.com/microsoft/homebrew-mssql-release/issues/83#issuecomment-1238369961
## Ref2: https://github.com/mkleehammer/pyodbc/issues/610#issuecomment-587523802
## Copy openssl.cnf to /etc/ssl/openssl.cnf
# RUN cp '/opt/init_scripts/openssl.cnf' '/etc/ssl/openssl.cnf'


## Install Google Chrome for Selenium web scraping
## Ref: https://reflect.run/articles/how-to-run-selenium-tests-inside-a-docker-container/
## Ref: https://www.youtube.com/watch?v=xrYDlx8evR0&list=WL&index=1&t=530s

# RUN apt-get update && apt-get install -y wget unzip
## For X86_64 (e.g. Windows, Mac Intel)
# RUN if [ "$TARGETPLATFORM" = "linux/amd64" ] \
#     ; then bash -c 'wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb && apt install -y ./google-chrome-stable_current_amd64.deb && rm google-chrome-stable_current_amd64.deb' \
#     ; fi
## For ARM64 (e.g. Mac M1/M2)
## https://www.reddit.com/r/docker/comments/p9u2l9/installing_chromium_for_arm64_on_docker/
# RUN if [ "$TARGETPLATFORM" = "linux/arm64" ] \
#     ; then bash -c 'apt install -y chromium' \
#     ; fi
# RUN apt-get cleanx

## Install custom Python libraries (with uv)
ENV VIRTUAL_ENV=/usr/local
RUN pip3 install uv
RUN uv pip install --no-cache -r /opt/init_scripts/${PIPENVFILE}

ENV PYTHONPATH="${PYTHONPATH}:/home/mage_code"
ENV PYTHONPATH="${PYTHONPATH}:/home/src"
ENV MAGE_DATA_DIR="/home/src/mage_data"

WORKDIR /home/src

# Start mage when container starts
CMD ["/bin/sh", "-c", "/home/src/script/activedirectory/login.sh;/app/run_app.sh"]