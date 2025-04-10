# run_ansible.sh
#!/bin/bash

set -e

# Debug logs
echo "Running Ansible playbook..."

# Run the Ansible playbook with localhost as inventory and use local connection
ansible-playbook ansible/get_nodes_ip.yaml -i localhost, -c local

# Verify if the JSON file exists
if [ ! -f /tmp/gke_ips.json ]; then
  echo '{"error": "JSON file not found"}'
  exit 1
fi

# Output the JSON content
cat /tmp/gke_ips.json