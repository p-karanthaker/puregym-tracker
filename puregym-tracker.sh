#!/bin/bash
# PureGym Tracking script
if [ ! -n "$1" ] || [ ! -n "$2" ]; then 
  echo "Usage: $0 LOGIN_EMAIL LOGIN_PIN"
  exit 1
fi

SCRIPT_LOCATION="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

LOGIN_PAGE='https://www.puregym.com/login/'
LOGIN_API='https://www.puregym.com/api/members/login'
MEMBERS_PAGE='https://www.puregym.com/members/'
EMAIL="$1"
PIN="$2"

COOKIE_1="$SCRIPT_LOCATION/cookie1"
COOKIE_2="$SCRIPT_LOCATION/cookie2"

LOGS="$SCRIPT_LOCATION/logs"
CSV_FILE="$LOGS/data.csv"
ERROR_LOG="$LOGS/puregym-error.log"
CSV_HEADER='Timestamp,People'

# Get requestVerificationToken + cookie from login page
requestVerificationToken=$(curl -s "$LOGIN_PAGE" -c "$COOKIE_1" | grep '__RequestVerificationToken' | sed 's/.* value=\"\(.*\)\".*/\1/')

# Send login request using requestVerificationToken and cookie1. Save login session cookie as cookie2
loginRequest=$(curl -s "$LOGIN_API" -H 'Content-Type: application/json' -H "__requestverificationtoken: "$requestVerificationToken"" -d "{\"email\":\"$EMAIL\",\"pin\":\"$PIN\"}" --compressed -b "$COOKIE_1" -c "$COOKIE_2")

# Go to members' page using session cookie2 and scrape data
numberOfPeople=$(curl -s "$MEMBERS_PAGE" -b "$COOKIE_2" | grep '[0-9]+\? people' | sed 's/.*>\([0-9]\{1,\}\).*/\1/')

appendData () {
  datetime=$(date '+%Y-%m-%d %H:%M:%S')

  if [ -n "$numberOfPeople" ] && [ ! -n "$loginRequest" ]; then
    if [ ! -f "$CSV_FILE" ]; then echo "$CSV_HEADER" > "$CSV_FILE"; fi
    echo "$datetime","$numberOfPeople" >> "$CSV_FILE"
  else
    if [ ! -f "$ERROR_LOG" ]; then touch "$ERROR_LOG"; fi
    echo -e "[ERROR] $datetime Unable to fetch data from PureGym. Reason: \n$loginRequest" >> "$ERROR_LOG"
  fi
}

appendData
rm {"$COOKIE_1","$COOKIE_2"}
