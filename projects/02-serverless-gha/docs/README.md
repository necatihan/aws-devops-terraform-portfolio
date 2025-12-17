# Serverless API on AWS (Terraform + GitHub Actions OIDC)

## What this project demonstrates
A production-style serverless API deployed with Terraform and delivered via GitHub Actions using AWS OIDC (no long-lived AWS keys).

**Highlights**
- Terraform remote state (S3 + KMS)
- GitHub Actions CI/CD:
  - plan on PR
  - apply on main
  - AWS auth via OIDC
- HTTP API Gateway + Lambda (Python) + DynamoDB
- Observability: access logs, structured Lambda logs, X-Ray tracing, alarms
- Basic hardening: API throttling + alarm notifications (SNS)

## Architecture
Client -> API Gateway (HTTP API) -> Lambda -> DynamoDB  
CloudWatch Logs + X-Ray + Alarms (SNS notifications)

## Endpoints
- `GET /health`
- `POST /items`
- `GET /items/{pk}`

## Quick demo (curl)
```bash
$ API_URL="https://qam63f1y8g.execute-api.eu-north-1.amazonaws.com"

$ curl -s "$API_URL/health"
{"service": "portfolio-serverless", "message": "healthy", "table": "aws-devops-terraform-portfolio-dev-items", "timestamp": 1765969542}

$ curl -s -X POST "$API_URL/items" \
  -H "content-type: application/json" \
  -d '{"pk":"demo#1","data":{"message":"hello","source":"upwork-portfolio"}}'
{"pk": "demo#1", "sk": "1765969551924#28fddf98", "item": {"pk": "demo#1", "sk": "1765969551924#28fddf98", "data": {"message": "hello", "source": "upwork-portfolio"}, "created_at": 1765969551}}

$ curl -s "$API_URL/items/demo%231"
{"pk": "demo#1", "count": 2, "items": [{"created_at": 1765967888, "pk": "demo#1", "data": {"message": "hello", "source": "upwork-portfolio"}, "sk": "1765967888666#01f468cd"}, {"created_at": 1765969551, "pk": "demo#1", "data": {"message": "hello", "source": "upwork-portfolio"}, "sk": "1765969551924#28fddf98"}]}

$ projects/02-serverless-gha/scripts/load_test.sh "$URL" "demo#load"
POST 20 items...
GET items...
{"pk": "demo#load", "count": 40, "items": [{"created_at": 1765969206, "pk": "demo#load", "data": {"n": 1, "source": "load_test"}, "sk": "1765969206127#c14d87be"}, {"created_at": 1765969206, "pk": "demo#load", "data": {"n": 2, "source": "load_test"}, "sk": "1765969206761#7616b1c4"}, {"created_at": 1765969207, "pk": "demo#load", "data": {"n": 3, "source": "load_test"}, "sk": "1765969207066#572c9295"
Done.
```

## CI/CD (GitHub Actions)
- Uses AWS OIDC to assume an IAM role (no stored AWS keys)
- Backend config comes from GitHub secrets:
  - TF_STATE_BUCKET
  - TF_STATE_KMS_KEY_ARN
  - GHA_TERRAFORM_ROLE_ARN

## Observability & Security
- API Gateway access logs -> CloudWatch log group
- Lambda structured JSON logs -> CloudWatch log group
- X-Ray tracing enabled
- CloudWatch alarms:
  - Lambda errors
  - Lambda throttles
  - API 5xx
- Alarm notifications via SNS email subscription