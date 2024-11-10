# NTNU IAC Assignment 2

## How to Apply

The workspace you are in determines the environment, but what variable file you use is not enforced.

### Manual Deployment
Ensure you are in the correct Terraform workspace, then plan using the appropriate `tfvars` file.

#### Commands

```bash
# Be inside the deployments folder
cd deployments

# Development environment
terraform select dev
terraform plan -var-file="dev.tfvars" -out="dev.tfplan"
terraform apply dev.tfplan
terraform destroy -var-file="dev.tfvars"

# Staging environment
terraform select stage
terraform plan -var-file="stage.tfvars" -out="stage.tfplan"
terraform apply stage.tfplan
terraform destroy -var-file="stage.tfvars"

# Production environment
terraform select prod
terraform plan -var-file="prod.tfvars" -out="prod.tfplan"
terraform apply prod.tfplan
terraform destroy -var-file="prod.tfvars"
```

### Automatic Deployment
When you push to the `dev` branch, it triggers a pipeline to test and create a pull request for the `stage` branch. If approved, it will deploy to stage and create a pull request for the `main` branch, which deploys to production when approved.