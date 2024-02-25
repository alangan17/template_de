#!/bin/bash

# Run this script in container, '/home/src'
# `bash /home/src/script/docker/03_test_dbt_debug.sh`
# Make sure you have `profiles.yml` in in the dbt folder

# Get the start time in seconds
start=$(date +%s)

# Connect to DCSTGSQL001
# Total time taken: 15 seconds
# Execution Datetime: 2024-02-22 20:24:45

# Connect to DCRPTSSQL001 (Failed)
# Total time taken: 10 seconds
# Execution Datetime: 2024-02-22 14:57:41

echo "Testing database connection using dbt debug..."
cd "/home/src/mage/dbt/on_cdw" && dbt debug --target prd_sink

# Check the status and report
if [ $? -eq 0 ]; then
    echo
    echo "Status: SUCCESS"
else
    echo
    echo "Status: FAILED"
fi

# Get the end time in seconds
end=$(date +%s)

# Calculate the duration
duration=$((end - start))

echo "Start time: ${start}"
echo "End time: ${end}"
echo "Total time taken: ${duration} seconds"

# Get and format the current date and time
execution_datetime=$(date '+%Y-%m-%d %H:%M:%S')
echo "Execution Datetime: ${execution_datetime}"
