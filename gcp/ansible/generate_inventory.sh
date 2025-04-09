#!/bin/bash

MASTER_IP=$(terraform output -raw master_ip)
NODE1_IP=$(terraform output -raw node1_ip)

cat > inventory.ini <<EOF
[kube_master]
master ansible_host=$MASTER_IP ansible_user=ubuntu ansible_ssh_private_key_file=/Users/maciek/.ssh/my_key

[kube_nodes]
node1 ansible_host=$NODE1_IP ansible_user=ubuntu ansible_ssh_private_key_file=/Users/maciek/.ssh/my_key

[kubernetes:children]
kube_master
kube_nodes
EOF
