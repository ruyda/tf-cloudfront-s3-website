// Get S3 bucket data
data "aws_s3_bucket" "website" {
  bucket = var.domain
}

// S3 permissions to allow CloudFront distribution access
data "aws_iam_policy_document" "origin_bucket_policy" {
  statement {
    sid    = "AllowCloudFrontServicePrincipalReadWrite"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = [ "cloudfront.amazonaws.com" ]
    }

    actions   = [ "s3:GetObject" ]
    resources = [ "${data.aws_s3_bucket.website.arn}/*" ]

    condition {
      test     = "StringEquals"
      variable = "AWS:SourceArn"
      values   = [aws_cloudfront_distribution.s3_distribution.arn]
    }
  }
}

resource "aws_s3_bucket_policy" "policy_attachment" {
  bucket = data.aws_s3_bucket.website.id
  policy = data.aws_iam_policy_document.origin_bucket_policy.json
}