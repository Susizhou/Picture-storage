data "aws_iam_policy_document" "igway-apps-codebuild-assume-role-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["codebuild.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "igway-apps-codebuild-policy" {
  name = "igway_apps_codebuild_policy"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Resource = [
          "arn:aws:logs:eu-west-2:${local.account_id}:log-group:${aws_cloudwatch_log_group.igway-apps-deploy-codebuild.name}:*"
        ]
        Action = [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
      }
    ]
  })

}

resource "aws_iam_role" "igway-apps-codebuild-role" {
  name                = "ncrs_int_codebuid_role"
  path                = "/"
  assume_role_policy  = data.aws_iam_policy_document.igway-apps-codebuild-assume-role-policy.json
  managed_policy_arns = [aws_iam_policy.igway-apps-codebuild-policy.arn]

}
