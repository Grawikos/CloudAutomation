#!/bin/bash

# Navigate to the infrastructure directory
cd infrastructure || { echo "Failed to navigate to infrastructure directory"; exit 1; }

# Initialize Terraform
if terraform init; then
  echo "Terraform initialized successfully"
else
  echo "Terraform initialization failed"
  exit 1
fi

# Apply the Terraform configuration
if terraform apply -auto-approve; then
  echo "Terraform apply executed successfully"
else
  echo "Terraform apply failed"
  exit 1
fi