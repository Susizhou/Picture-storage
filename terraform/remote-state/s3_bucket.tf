resource "aws_s3_bucket" "terraform_state" {
  bucket = "susizhou-picture-storage-terraform-state-backend"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.bucket
  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

resource "aws_s3_bucket_public_access_block" "terraform_state" {
  bucket                  = aws_s3_bucket.terraform_state.id
  block_public_acls       = true
  block_public_policy     = true
  restrict_public_buckets = true
  ignore_public_acls      = true
}

data "aws_iam_policy_document" "terraform_state_bucket_policy" {
  policy_id = aws_s3_bucket.terraform_state.bucket

  statement {
    sid       = "DenyNonSSLAccess"
    effect    = "Deny"
    resources = ["${aws_s3_bucket.terraform_state.arn}/*"]
    actions   = ["s3:GetObject"]

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values   = ["false"]
    }

    principals {
      identifiers = ["*"]
      type        = "*"
    }
  }
}

resource "aws_s3_bucket_policy" "terraform_state" {
  bucket = aws_s3_bucket.terraform_state.id
  policy = data.aws_iam_policy_document.terraform_state_bucket_policy.json
}