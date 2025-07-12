#!/bin/bash
set -e

sf org login jwt \
  --username "$SF_USERNAME" \
  --jwt-key-file "$SERVER_KEY_FILE" \
  --client-id "$SF_CONSUMER_KEY" \
  --instance-url "$LOGIN_URL" \
  --alias "$ORG_ALIAS" \
  --set-default