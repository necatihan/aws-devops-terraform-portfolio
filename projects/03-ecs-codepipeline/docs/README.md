# ECS + CodePipeline CI/CD (Terraform) — Portfolio Project

This project demonstrates an end-to-end **AWS-native CI/CD pipeline** that builds and deploys a containerized web app to **Amazon ECS (Fargate)** behind an **Application Load Balancer (ALB)**.

**Tech highlights**
- Infrastructure as Code: **Terraform**
- Container runtime: **ECS Fargate**
- Load balancing: **ALB**
- Container registry: **ECR**
- CI/CD: **CodePipeline + CodeBuild**
- GitHub integration: **CodeStar Connection**
- Observability: **CloudWatch Logs**, ECS service events, ALB health checks

---

## What you get

✅ Push/merge to `main` → pipeline runs automatically  
✅ Docker image is built in CodeBuild and pushed to ECR (tags: `latest` + commit SHA)  
✅ ECS service updates and performs a rolling deployment  
✅ App becomes available via ALB URL (HTTP 200)

---

## Architecture

```mermaid
flowchart LR
  Dev[Developer / GitHub] -->|merge to main| CP[CodePipeline]
  CP -->|Source| CS[CodeStar Connection]
  CP -->|Build| CB[CodeBuild]
  CB -->|docker build/push| ECR[(ECR Repository)]
  CP -->|Deploy using imagedefinitions.json| ECS[ECS Service - Fargate]
  ECS --> ALB[Application Load Balancer]
  ALB --> User[Browser / curl]