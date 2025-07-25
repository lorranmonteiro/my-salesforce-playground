#!/bin/bash
set -e

sf org login jwt \
  --username $SF_USERNAME \
  --client-id $SF_CONSUMER_KEY \
  --jwt-key-file .secure_files/server.key \
  --instance-url https://login.salesforce.com \
  --alias Playground \
  --set-default
