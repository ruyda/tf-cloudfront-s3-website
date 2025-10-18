locals {
  domain_name         = split(".", var.domain)[0] // ex: google.com -> google 
  s3_origin_id        = "${local.domain_name}-s3-website-origin"
  acm_certificate_arn = var.use_existing_ssl_certificate ? data.aws_acm_certificate.existing_ssl_certificate[0].arn : aws_acm_certificate.ssl_certificate[0].arn
}

resource "aws_cloudfront_origin_access_control" "s3_oac" {
  name                              = "${local.domain_name}-oac"
  description                       = "S3 static website OAC"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  depends_on = [ aws_acm_certificate_validation.cert_validation ]

  origin {
    domain_name              = data.aws_s3_bucket.website.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.s3_oac.id
    origin_id                = local.s3_origin_id
  }

  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_100" // North America, Europe, and Israel
  aliases             = [ "${var.domain}", "www.${var.domain}" ]

  default_cache_behavior {
    allowed_methods          = [ "DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT" ]
    cached_methods           = [ "GET", "HEAD" ]
    target_origin_id         = local.s3_origin_id
    min_ttl                  = 0
    default_ttl              = 3600
    max_ttl                  = 86400
    cache_policy_id          = var.distribution_caching_policy_id
    origin_request_policy_id = var.origin_request_policy_id
    viewer_protocol_policy   = "redirect-to-https"
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    acm_certificate_arn = local.acm_certificate_arn
    minimum_protocol_version = "TLSv1.2_2021"
    ssl_support_method  = "sni-only"
  }

  tags = {
    Name = "cloudfront.${var.domain}"
  }
}