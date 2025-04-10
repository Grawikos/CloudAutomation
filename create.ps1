# Navigate to the infrastructure directory
if (-not (Set-Location -Path "infrastructure" -ErrorAction SilentlyContinue)) {
    Write-Host "Failed to navigate to infrastructure directory"
    exit 1
}

# Initialize Terraform
if (terraform init) {
    Write-Host "Terraform initialized successfully"
} else {
    Write-Host "Terraform initialization failed"
    exit 1
}

# Apply the Terraform configuration
if (terraform apply -auto-approve) {
    Write-Host "Terraform apply executed successfully"
} else {
    Write-Host "Terraform apply failed"
    exit 1
}

# Navigate back to the parent directory
Set-Location -Path ".."

# Execute the security group setup script

if (& ./fillsecgroup.sh {here paste nodes ip like "111.111.111.111/32" "111.111.111.111/32" "111.111.111.111/32"}) {
    Write-Host "Security group configured successfully"
} else {
    Write-Host "Security group setup failed"
    exit 1
}

# Execute the reverse proxy setup script
if (& ./createReverseProxy.sh {here paste loadbalancer ip like "111.111.111.111"}) {
    Write-Host "Reverse proxy created successfully"
} else {
    Write-Host "Reverse proxy setup failed"
    exit 1
}

# Navigate back to the infrastructure directory
if (-not (Set-Location -Path "infrastructure" -ErrorAction SilentlyContinue)) {
    Write-Host "Failed to navigate to infrastructure directory"
    exit 1
}

# Run the Ansible playbook for deployment
if (ansible-playbook ansible/deploy_cloudshirt.yaml -e "@vars.yml") {
    Write-Host "CloudShirt deployment completed successfully"
} else {
    Write-Host "CloudShirt deployment failed"
    exit 1
}

# Run the Ansible playbook for log collection
if (ansible-playbook ansible/collect-logs.yaml -e "@vars.yml") {
    Write-Host "Logs collected successfully"
} else {
    Write-Host "Log collection failed"
    exit 1
}
