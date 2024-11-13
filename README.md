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
When you make a pull request to `dev`, `stage` or `prod` branch, it triggers a pipeline to test and deploy the code - `pipeline.yml` file.

The branches `stage` and `prod` are protected from push.

The github environments `stage` and `prod` needs manual confirmation before it is applied. It is not deployed to azure unless approved.

# act

You can test each workflow locally using act, however you need to specify .secrets folder somewhere with azure credentials. I recommend not having the secrets folder withing the project files. The github actions are mocked, but the deployment to azure is not.

test
```bash
act -j terraform_test
```

deploy
```bash
act -j terraform_deploy --env GITHUB_REF_NAME=dev
act -j terraform_deploy --env GITHUB_REF_NAME=stage
act -j terraform_deploy --env GITHUB_REF_NAME=prod
```

destroy
```bash
act workflow_dispatch -j terraform_destroy --input environment=dev
act workflow_dispatch -j terraform_destroy --input environment=stage
act workflow_dispatch -j terraform_destroy --input environment=prod
```

The pipeline takes test and deploy together and automates the process, the above is just units (workflow_call and workflow_dispatch)