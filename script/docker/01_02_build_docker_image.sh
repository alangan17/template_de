#!/bin/bash

# to clear all build caches, use `docker system prune -a`

# Get current date and time in YYYY-MM-DD HH:MM:SS format
datetime=$(date '+%Y-%m-%d %H:%M:%S')
echo "Current datetime: $datetime"

# Correctly handle leading zeros in time calculation
# Get start time in hundredths of a second, ensuring no leading zeros cause issues
start=$(date +%s)

echo "Start building image..."
# Create the conda environment and automatically approve prompts
docker compose build

# Check the status and report
if [ $? -eq 0 ]; then
    echo -e "\nStatus: SUCCESS"
else
    echo -e "\nStatus: FAILED"
fi

# Get end time in hundredths of a second, ensuring no leading zeros cause issues
end=$(date +%s)

# Calculate the duration
duration=$((end - start))

echo "Start time: ${start}"
echo "End time: ${end}"
echo "Total time taken: $duration seconds"

# Format the current date and time
curDate=$(date '+%Y-%m-%d')
curTime=$(date '+%H:%M:%S')
