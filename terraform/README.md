# Terraform Deployment (Cloud Notes App)

This folder contains a second, independent deployment of the Cloud Notes App
backend, built with **Terraform** instead of AWS SAM. It replicates the same
architecture as the SAM stack, deployed as separate AWS resources so both
can run side by side.

## Why this exists

The original app was built and deployed using AWS SAM/CloudFormation. This
Terraform version was added to demonstrate the same infrastructure defined
with a different IaC tool — useful for comparing approaches and for
portfolio purposes.

## Architecture

Same as the SAM stack:

- **AWS Lambda** (Python 3.12) — runs `backend/app.py`, handler `app.lambda_handler`
- **API Gateway (REST API)** — routes: `GET /notes`, `POST /notes`, `GET /notes/{id}`, `DELETE /notes/{id}`
- **DynamoDB table** (`NotesTable-tf`) — primary key `noteId` (String), on-demand billing
- **IAM role** scoped to only allow CRUD actions on the `NotesTable-tf` table (least privilege)

Resources are named with a `-tf` suffix and deployed independently from the
SAM stack, so the two do not share or conflict over any AWS resources.

## Files

| File | Purpose |
|---|---|
| `provider.tf` | AWS provider + Terraform version config |
| `variables.tf` | Project name, region, table name |
| `dynamodb.tf` | DynamoDB table definition |
| `iam.tf` | Lambda execution role + scoped DynamoDB policy |
| `lambda.tf` | Lambda function + zip packaging of `../backend` |
| `api_gateway.tf` | REST API, resources, methods, Lambda proxy integrations, deployment/stage |
| `outputs.tf` | API URL, table name, function name |

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) >= 1.5.0
- AWS CLI configured with credentials (`aws configure` or `aws sts get-caller-identity` to confirm)
- `backend/app.py` and `backend/requirements.txt` present one level up

## Deploy

```bash
cd terraform
terraform init
terraform plan
terraform apply
```

Confirm with `yes` when prompted. On success, Terraform prints the live API URL.

## Test

```powershell
# Create a note
Invoke-RestMethod -Uri "<api_url>" -Method POST -ContentType "application/json" -Body '{"title":"Test","content":"Hello"}'

# List notes
Invoke-RestMethod -Uri "<api_url>" -Method GET
```

## Tear down

```bash
terraform destroy
```

This removes only the Terraform-managed resources (the `-tf` suffixed ones)
and has no effect on the original SAM stack.

## SAM vs. Terraform: notes from this project

- SAM's `DynamoDBCrudPolicy` is a convenient shorthand for a scoped IAM
  policy; in Terraform this was written out explicitly as an inline
  `aws_iam_role_policy`.
- SAM handles packaging Lambda code via `sam build`; Terraform uses the
  `archive_file` data source to zip the `backend/` folder automatically
  on `plan`/`apply`.
- SAM's `AWS::Serverless::Function` implicitly creates API Gateway
  event sources; in Terraform each route/method/integration is defined
  explicitly (`aws_api_gateway_resource`, `_method`, `_integration`).
