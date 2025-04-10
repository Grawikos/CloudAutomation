#!/bin/bash

# Execute the security group and reverse proxy setup scripts
if ./fillsecgroup.sh { here paste nodes ip like "111.111.111.111/32" "111.111.111.111/32" "111.111.111.111/32"}; then
  echo "Security group configured successfully"
else
  echo "Security group setup failed"
  exit 1
fi

if ./createReverseProxy.sh { here paste loadbalancer ip like "111.111.111.111" }; then
  echo "Reverse proxy created successfully"
else
  echo "Reverse proxy setup failed"
  exit 1
fi

# Navigate to the infrastructure directory
cd infrastructure || { echo "Failed to navigate to infrastructure directory"; exit 1; }

# Run the Ansible playbooks using the provided variables file
if ansible-playbook ansible/deploy_cloudshirt.yaml -e "@vars.yml"; then
  echo "CloudShirt deployment completed successfully"
else
  echo "CloudShirt deployment failed"
  exit 1
fi