resource "aws_iam_role" "codebuild" {
  name = "${var.project}-${var.env}-codebuild-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "codebuild.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "codebuild_basic" {
  role       = aws_iam_role.codebuild.name
  policy_arn = "arn:aws:iam::aws:policy/AWSCodeBuildDeveloperAccess"
}

resource "aws_cloudwatch_log_group" "codebuild" {
  name              = "/codebuild/${var.project}-${var.env}-docker-build"
  retention_in_days = 14
}

# Allow pushing to your specific ECR repo
data "aws_iam_policy_document" "codebuild_ecr" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:GetAuthorizationToken"
    ]
    resources = ["*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "ecr:BatchCheckLayerAvailability",
      "ecr:CompleteLayerUpload",
      "ecr:GetDownloadUrlForLayer",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage",
      "ecr:UploadLayerPart"
    ]
    resources = [aws_ecr_repository.app.arn]
  }
}

data "aws_iam_policy_document" "codebuild_logs" {
  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams"
    ]
    resources = ["${aws_cloudwatch_log_group.codebuild.arn}:*"]
  }
}

resource "aws_iam_policy" "codebuild_logs" {
  name   = "${var.project}-${var.env}-codebuild-logs"
  policy = data.aws_iam_policy_document.codebuild_logs.json
}

resource "aws_iam_role_policy_attachment" "codebuild_logs" {
  role       = aws_iam_role.codebuild.name
  policy_arn = aws_iam_policy.codebuild_logs.arn
}

data "aws_iam_policy_document" "codebuild_artifacts_s3" {
  statement {
    effect = "Allow"
    actions = [
      "s3:GetObject",
      "s3:GetObjectVersion",
      "s3:PutObject"
    ]
    resources = ["${aws_s3_bucket.pipeline_artifacts.arn}/*"]
  }

  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket",
      "s3:GetBucketLocation"
    ]
    resources = [aws_s3_bucket.pipeline_artifacts.arn]
  }
}

resource "aws_iam_policy" "codebuild_artifacts_s3" {
  name   = "${var.project}-${var.env}-codebuild-artifacts-s3"
  policy = data.aws_iam_policy_document.codebuild_artifacts_s3.json
}

resource "aws_iam_role_policy_attachment" "codebuild_artifacts_s3" {
  role       = aws_iam_role.codebuild.name
  policy_arn = aws_iam_policy.codebuild_artifacts_s3.arn
}

resource "aws_iam_policy" "codebuild_ecr" {
  name   = "${var.project}-${var.env}-codebuild-ecr"
  policy = data.aws_iam_policy_document.codebuild_ecr.json
}

resource "aws_iam_role_policy_attachment" "codebuild_ecr" {
  role       = aws_iam_role.codebuild.name
  policy_arn = aws_iam_policy.codebuild_ecr.arn
}

resource "aws_codebuild_project" "docker_build" {
  name         = "${var.project}-${var.env}-docker-build"
  service_role = aws_iam_role.codebuild.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = "BUILD_GENERAL1_SMALL"
    image           = "aws/codebuild/standard:7.0"
    type            = "LINUX_CONTAINER"
    privileged_mode = true
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "projects/03-ecs-codepipeline/buildspec.yml"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = aws_cloudwatch_log_group.codebuild.name
      stream_name = "build"
    }
  }
}