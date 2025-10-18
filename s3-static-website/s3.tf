data "aws_caller_identity" "current" {}

# Create S3 bucket for website access logs
resource "aws_s3_bucket" "access_logs" {
  count  = var.use_access_logging ? 1 : 0
  bucket = "logs.${var.domain}"
}

data "aws_iam_policy_document" "logs_policy_doc" {
  count = var.use_access_logging ? 1 : 0
  statement {
    principals {
      identifiers = ["logging.s3.amazonaws.com"]
      type        = "Service"
    }
    actions   = ["s3:PutObject"]
    resources = ["${aws_s3_bucket.access_logs[0].arn}/*"]
    condition {
      test     = "StringEquals"
      variable = "aws:SourceAccount"
      values   = [data.aws_caller_identity.current.account_id]
    }
  }
}

resource "aws_s3_bucket_policy" "logs_policy" {
  count  = var.use_access_logging ? 1 : 0
  bucket = aws_s3_bucket.access_logs[0].bucket
  policy = data.aws_iam_policy_document.logs_policy_doc[0].json
}

# Create S3 bucket for website contents and setup access logs
resource "aws_s3_bucket" "website" {
  bucket = var.domain
}

resource "aws_s3_bucket_website_configuration" "website_configuration" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_logging" "access_logging" {
  count  = var.use_access_logging ? 1 : 0
  bucket = aws_s3_bucket.website.bucket

  target_bucket = aws_s3_bucket.access_logs[0].bucket
  target_prefix = "log/"
  target_object_key_format {
    partitioned_prefix {
      partition_date_source = "EventTime"
    }
  }
}

# Upload files in given path to S3 static website bucket
resource "aws_s3_object" "files" {
  for_each     = fileset("${var.website_contents_path}/", "**")
  bucket       = aws_s3_bucket.website.id
  key          = each.key
  source       = "${var.website_contents_path}/${each.value}"
  content_type = each.value
  etag         = filemd5("${var.website_contents_path}/${each.value}")
}