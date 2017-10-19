#!/bin/bash
# PureGym Tracking script
SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

LOGIN_PAGE='https://www.puregym.com/login/'
LOGIN_API='https://www.puregym.com/api/members/login'
MEMBERS_PAGE='https://www.puregym.com/members/'
EMAIL='YOUR_EMAIL'
PIN='YOUR_PIN'

COOKIE_1="$SCRIPT_LOCATION/cookie1"
COOKIE_2="$SCRIPT_LOCATION/cookie2"

CSV_FILE="$HOME/data.csv"
CSV_HEADER='Timestamp,People'

# Get requestVerificationToken + cookie from login page
requestVerificationToken=$(curl "$LOGIN_PAGE" -c "$COOKIE_1" | grep '__RequestVerificationToken' | sed 's/.* value=\"\(.*\)\".*/\1/')

# Send login request using requestVerificationToken and cookie1. Save login session cookie as cookie2
curl "$LOGIN_API" -H 'Content-Type: application/json' -H "__requestverificationtoken: "$requestVerificationToken"" -d "{\"associateAccount\":\"false\",\"email\":\"$EMAIL\",\"pin\":\"$PIN\"}" --compressed -b "$COOKIE_1" -c "$COOKIE_2"

# Go to members' page using session cookie2 and scrape data
numberOfPeople=$(curl "$MEMBERS_PAGE" -b "$COOKIE_2" | grep '[0-9]+\? people' | sed 's/.*>\([0-9]\{1,\}\).*/\1/')

appendData () {
  datetime=$(date '+%Y-%m-%d %H:%M:%S')
  echo "$datetime","$numberOfPeople" >> "$CSV_FILE"
}

# Create data file if it doesn't exist. Otherwise append data to it.
if [ ! -f "$CSV_FILE" ]; then
  echo "$CSV_HEADER" > "$CSV_FILE"
  appendData
else
  appendData
fi

rm {"$COOKIE_1","$COOKIE_2"}
