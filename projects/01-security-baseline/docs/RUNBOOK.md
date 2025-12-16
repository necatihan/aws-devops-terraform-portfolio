# Security Baseline Runbook

## What this baseline provides
- CloudTrail (multi-region) writing encrypted audit logs to S3
- AWS Config recorder + delivery channel
- Core compliance rules:
  - S3 public read prohibited
  - S3 public write prohibited
  - Encrypted volumes
  - CloudTrail enabled
- GuardDuty enabled for threat detection
- Alerting pipeline: GuardDuty Finding -> EventBridge -> SNS email

## Verification checklist (5 minutes)
1) CloudTrail
- Console: CloudTrail -> Trails -> `portfolio-org-trail`
- Confirm: multi-region ON, log file validation ON
- Confirm logs in S3: `cloudtrail_bucket/AWSLogs/<account-id>/CloudTrail/`

2) AWS Config
- Console: AWS Config -> Settings
- Recorder: ON
- Delivery channel: present
- Rules: show compliance status after initial evaluation
- Confirm objects in S3: `config_bucket/AWSLogs/<account-id>/Config/`

3) GuardDuty
- Console: GuardDuty -> Detector: Enabled

4) Alerts
- Confirm SNS subscription email accepted
- EventBridge rule exists: `...guardduty-findings`

## Incident response: GuardDuty finding received
1) Open the finding in GuardDuty
2) Identify resource (instance, IAM user, access key, etc.)
3) Immediate containment examples:
- IAM: disable access key / revoke sessions
- EC2: isolate SG / stop instance
4) Investigate:
- CloudTrail events around the time of the finding
- Look for unusual API calls, new IAM policies, security group changes
5) Eradicate and recover:
- remove malicious persistence
- rotate credentials
6) Post-incident:
- document root cause
- add preventive control (Config rule, SCP, tighter IAM)