#!/bin/bash

# Navigate to the infrastructure directory
cd infrastructure || { echo "Failed to navigate to infrastructure directory"; exit 1; }

if ansible-playbook ansible/collect-logs.yaml -e "@vars.yml"; then
  echo "Logs collected successfully"
else
  echo "Log collection failed"
  exit 1
fi