#!/bin/bash
echo "Destroying Terraform resources..."
terraform destroy -auto-approve

echo "Deleting Terraform state files..."
rm -rf .terraform/ terraform.tfstate* .terraform.lock.hcl

echo "Cleanup complete!"
