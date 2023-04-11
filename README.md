# CloudWatch-Alarms with terraform

## Background Story: 
Your company runs services in AWS across 3 different regions. The DevOps team manages a stack of 30 CloudWatch alarms for every region, which means, (3 regions) * (30 alarms) = 90 different alarms.

## Feature 
- This project create CloudWatch alarms with jenkins pipeline in the region you choose.
- You can create and destroy resources with terraform.
- separate state for each region to avoid collision with workspaces.


## Directory Structure

```
tf_alarm/
├── alarms.Jenkinsfile
├── environments
│   ├── dev.tfvars
│   └── prod.tfvars
├── main.tf
├── backend.tf
├── outputs.tf
├── regions
│   ├── eu-central-1-prod.tfvars
│   ├── us-east-1-dev.tfvars
│   ├── us-east-1-prod.tfvars
│   └── us-west-1-prod.tfvars
└── variables.tf
```


- `main.tf` contains configurations of 3 CloudWatch alarms, as well as sns topic 
- `backend.tf` contain Terraform block with the relevant provider and an S3 backend
- `variables.tf` and `outputs.tf`: contain variable definitions and outputs
- `environments` directory: contains .tfvars files with per-env variable assignments
- `regions` directory: contains .tfvars files with per-region variable assignments
- `alarms.Jenkinsfile`: an almost ready-to-use Jenkinsfile to integrate the alarms pipeline in your Jenkins server


## Acknowledgments

- [Terraform documentation](https://www.terraform.io/docs/index.html)
- [AWS CloudWatch documentation](https://docs.aws.amazon.com/AmazonCloudWatch/latest/monitoring/WhatIsCloudWatch.html)
