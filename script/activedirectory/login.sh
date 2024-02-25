#!/bin/bash
# Ref: https://transpose.dk/blog/using-sql-server-linux-docker-container-using-windows-authentication
# To execute the script `bash /home/src/script/activedirectory/login.sh`

# To check if the container is authenicated, run `klist` in shell

# Change system timezone
# Note: Mage uses UTC by default, this might affect the Mage Dashboard display
# ln -sf /usr/share/zoneinfo/$TIMEZONE /etc/localtime

if [[ "$NEED_JOIN_DOMAIN" == "False" ]]; then
    echo "NEED_JOIN_DOMAIN is set to False. Quitting."
    exit 0  # Exit with success status
fi

# Check that variables are set
if [[ -z "$ACTIVE_DIRECTORY_USER" ]]; then
    echo "Need to set ACTIVE_DIRECTORY_USER as Docker Env Var" 1>&2
    exit 1
fi

if [[ -z "$ACTIVE_DIRECTORY_PW" ]]; then
    echo "Need to set ACTIVE_DIRECTORY_PW as Docker Env Var" 1>&2
    exit 1
fi

# Copy krb5.conf to /etc/krb5.conf
cp /home/src/script/activedirectory/krb5.conf /etc/krb5.conf

# Get the Ticket-Granting-Ticket for Kerberos
kinit "$ACTIVE_DIRECTORY_USER" <<< "$ACTIVE_DIRECTORY_PW" || exit 1

# Create key tab
ktutil < <(echo -e "addent -password -p $ACTIVE_DIRECTORY_USER -k 1 -e aes256-cts-hmac-sha1-96\n$ACTIVE_DIRECTORY_PW\nwkt /etc/krb5.keytab \nquit")

# Cron doensn't have access to enviormental variables. Hence we need to export ACTIVE_DIRECTORY_USER.
declare -p | grep -E 'ACTIVE_DIRECTORY_USER' > /home/src/script/activedirectory/container.env

# Schedule the cronjob
## TOFIX: crontab not running (Exception: bad minute)
# crontab /home/src/script/activedirectory/crontab

# Start cron and run the scehdule
# cron