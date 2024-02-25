#!/bin/bash
# Purpose: Setup the project for the first time
# Run this in the repo root directory

mkdir data
echo "Created data directory"

echo "Environment variables:"
cp env.sample .env
echo "Copied env.sample to .env"

echo "Active Directory config:"
cp devops/mage/scripts/openssl.cnf.sample devops/mage/scripts/openssl.cnf
echo "Copied devops/mage/scripts/openssl.cnf.sample to devops/mage/scripts/openssl.cnf"

echo "SQL Server config:"
cp script/activedirectory/krb5.conf.sample script/activedirectory/krb5.conf
echo "Copied script/activedirectory/krb5.conf.sample to script/activedirectory/krb5.conf"

# Remove the existing mage project folder
rm -rf my_de_project