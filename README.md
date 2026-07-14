<img width="1037" height="1017" alt="Screenshot 2026-07-14 141129" src="https://github.com/user-attachments/assets/cc565477-d40d-49b9-b694-060762828f71" />
# Cloud Notes App

A serverless REST API for creating, retrieving, and deleting notes, built on AWS using a fully serverless architecture with Infrastructure as Code.

## Architecture
- **AWS Lambda** — runs the API logic (Python)
- **Amazon API Gateway** — exposes REST endpoints (GET, POST, DELETE)
- **Amazon DynamoDB** — stores notes (NoSQL)
- **AWS SAM** — defines and deploys all infrastructure as code (`template.yaml`)

## Endpoints
| Method | Path         | Description        |
|--------|-------------|---------------------|
| GET    | /notes      | Get all notes       |
| POST   | /notes      | Create a new note    |
| GET    | /notes/{id} | Get a single note   |
| DELETE | /notes/{id} | Delete a note       |

## Why this design
- Lambda + API Gateway means no server to manage or pay for when idle — cost scales with actual usage
- IAM permissions are scoped with SAM's `DynamoDBCrudPolicy`, so the Lambda function can only access its own table (least privilege)
- Docker was used to build in a container matching Lambda's exact Python runtime, avoiding local/deployment version mismatches

## Deploy it yourself
```bash
sam build --use-container
sam deploy --guided
```

## Tech stack
AWS Lambda, API Gateway, DynamoDB, SAM, Python, Docker
