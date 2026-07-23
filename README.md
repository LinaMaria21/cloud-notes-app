http://lina-cloud-notes-frontend.s3-website-us-east-1.amazonaws.com/

<img width="1037" height="1017" alt="Screenshot 2026-07-14 141129" src="https://github.com/user-attachments/assets/cc565477-d40d-49b9-b694-060762828f71" />
# Cloud Notes App

A serverless REST API for creating, retrieving, and deleting notes, built with Python and deployed on AWS using Infrastructure as Code.

This project demonstrates cloud-native application development using AWS Lambda, API Gateway, DynamoDB, and AWS SAM. The application was designed with scalability, security, and cost efficiency in mind.

## Architecture

- **AWS Lambda** — Executes backend API logic using Python
- **Amazon API Gateway** — Provides REST API endpoints
- **Amazon DynamoDB** — Stores application data using a NoSQL database
- **AWS SAM (Serverless Application Model)** — Defines and deploys infrastructure as code
- **Docker** — Used for building inside the Lambda-compatible Python runtime environment

## API Endpoints

| Method | Path | Description |
|---|---|---|
| GET | `/notes` | Retrieve all notes |
| POST | `/notes` | Create a new note |
| GET | `/notes/{id}` | Retrieve a single note |
| DELETE | `/notes/{id}` | Delete a note |

## Design Decisions

### Serverless Architecture
Lambda and API Gateway eliminate server management and allow the application to scale automatically based on demand.

### Infrastructure as Code
AWS SAM is used to define cloud resources, allowing repeatable and consistent deployments.

### Security
IAM permissions follow the principle of least privilege. Lambda access to DynamoDB is restricted using SAM-managed policies.

### Container-Based Builds
Docker is used with AWS SAM to build the application using the same runtime environment as AWS Lambda, reducing dependency and deployment issues.

## Deployment

Prerequisites:
- AWS CLI configured
- AWS SAM CLI installed
- Docker installed

Build:

```bash
sam build --use-container
