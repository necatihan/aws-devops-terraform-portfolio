data "aws_caller_identity" "current" {}

# GitHub OIDC provider
resource "aws_iam_openid_connect_provider" "github" {
  url = "https://token.actions.githubusercontent.com"

  client_id_list = [
    "sts.amazonaws.com"
  ]

  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

data "aws_iam_policy_document" "gha_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [aws_iam_openid_connect_provider.github.arn]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"
      values   = ["sts.amazonaws.com"]
    }

    # Lock to YOUR repo and main branch only
    condition {
      test     = "StringLike"
      variable = "token.actions.githubusercontent.com:sub"
      values   = [
        "repo:${var.repo}:ref:refs/heads/main",
        "repo:${var.repo}:pull_request"
      ]
    }
  }
}

resource "aws_iam_role" "gha_terraform" {
  name               = "${var.project}-${var.env}-gha-terraform"
  assume_role_policy = data.aws_iam_policy_document.gha_assume_role.json
}

# Start with wide permissions for speed; we'll tighten later
resource "aws_iam_role_policy_attachment" "gha_admin" {
  role       = aws_iam_role.gha_terraform.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

output "gha_role_arn" {
  value = aws_iam_role.gha_terraform.arn
}