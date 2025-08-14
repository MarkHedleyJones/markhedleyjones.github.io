#!/bin/bash

# Load credentials from .env file
if [ -f .env ]; then
  source .env
  USERNAME=$UMAMI_USERNAME
  PASSWORD=$UMAMI_PASSWORD
else
  echo "Error: .env file not found. Please create it with UMAMI_USERNAME and UMAMI_PASSWORD"
  exit 1
fi

if [ -z "$USERNAME" ] || [ -z "$PASSWORD" ]; then
  echo "Error: Please set UMAMI_USERNAME and UMAMI_PASSWORD in .env file"
  exit 1
fi

# Get auth token
RESPONSE=$(curl -s -X POST https://umami-analytic.netlify.app/api/auth/login \
  -H "Content-Type: application/json" \
  -d "{\"username\":\"$USERNAME\",\"password\":\"$PASSWORD\"}")

echo "Response: $RESPONSE"

# Extract token if successful
TOKEN=$(echo $RESPONSE | grep -o '"token":"[^"]*' | sed 's/"token":"//')

if [ ! -z "$TOKEN" ]; then
  echo "Token obtained successfully!"
  echo "TOKEN=$TOKEN" > /tmp/umami_token.env
  echo "Token saved to /tmp/umami_token.env"
else
  echo "Failed to get token. Check your credentials."
fi