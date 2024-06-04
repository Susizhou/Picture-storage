resource "aws_codebuild_project" "picture-storage-pipeline" {
  name          = "ncrs-int-deployment"
  description   = "deploys ncrs integration testing environment"
  build_timeout = 5
  service_role  = aws_iam_role.igway-apps-codebuild-role.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name = aws_cloudwatch_log_group.igway-apps-deploy-codebuild.name
    }
  }

  source {
    type            = "GITHUB"
    location        = "https://github.com/Susizhou/Picture-storage.git"
    git_clone_depth = 1
  }

  source_version = "main"
}

resource "aws_codebuild_webhook" "igway-apps-deploy-webhook" {
  project_name = aws_codebuild_project.picture-storage-pipeline.name
  build_type   = "BUILD"
  filter_group {
    filter {
      type    = "EVENT"
      pattern = "WORKFLOW_JOB_QUEUED"
    }
  }
}

## cloudwatch setup
resource "aws_cloudwatch_log_group" "igway-apps-deploy-codebuild" {
  name              = "/aws/codebuild/igway-apps-deploy-codebuild"
  retention_in_days = 3
}
