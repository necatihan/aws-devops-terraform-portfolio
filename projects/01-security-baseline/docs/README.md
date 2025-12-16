# Security Baseline — CloudTrail Logging

## What this provides
- Multi-region CloudTrail capturing management events
- Encrypted, versioned S3 log bucket (SSE-KMS)
- TLS-only bucket policy + least-privilege CloudTrail write access
- Lifecycle retention to control costs

## How to verify
1. CloudTrail → Trails → confirm enabled + multi-region + validation
2. S3 bucket → AWSLogs/<account-id>/ → confirm logs landing

## Why it matters (non-technical)
This creates an immutable audit trail of who did what in AWS, which is essential for security, compliance, and incident investigation.