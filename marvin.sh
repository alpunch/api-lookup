#!/bin/bash
# TODO: HELP, H2G2 explicit ref
# Run Packer : Create AMI
packer build -force -var-file=secret.provider.auto.tfvars packer-image.json
# Run Terraform : Build infra
#terraform plan
#terraform apply
# Run Ansible : Custom infra
#ansible-playbook
# Run procet test :
# - Enter address
# - Do curl on create API endpoint
