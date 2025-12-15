# AWS DevOps Terraform Portfolio

A set of production-style AWS DevOps projects built with Terraform, focused on:
- repeatable infrastructure (IaC)
- CI/CD pipelines
- observability (logs/metrics/alarms)
- security guardrails
- operational runbooks + cost notes

## Projects
- **00 - Foundation**: remote state + shared standards
- **01 - Security Baseline**: CloudTrail, Config, GuardDuty, centralized logging
- **02 - Serverless + GitHub Actions**: API Gateway/Lambda/DynamoDB + tracing + OIDC CI/CD
- **03 - ECS Fargate + CodePipeline**: blue/green deployments + rollback + alarms
- **04 - EKS + GitOps**: Argo CD delivery flow + policy guardrails

## Repo standards
- Terraform version pinned
- CI checks on PRs
- No secrets in repo
- Each project includes README + architecture + runbook