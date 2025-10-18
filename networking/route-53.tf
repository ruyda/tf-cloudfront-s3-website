locals {
  use_route_53    = var.dns_type == "NEW_ROUTE_53" || var.dns_type == "EXISTING_ROUTE_53"
  hosted_zone_id  = var.dns_type == "NEW_ROUTE_53" ? aws_route53_zone.new_hosted_zone[0].zone_id : data.aws_route53_zone.existing_hosted_zone[0].zone_id
  acm_certificate = var.use_existing_ssl_certificate ? data.aws_acm_certificate.existing_ssl_certificate[0] : aws_acm_certificate.ssl_certificate[0]
}

# Configure using an existing Route 53 hosted zone
data "aws_route53_zone" "existing_hosted_zone" {
  count = var.dns_type == "EXISTING_ROUTE_53" ? 1 : 0
  name  = var.domain
}

# Configure a Route 53 registered domain with a new hosted zone
resource "aws_route53_zone" "new_hosted_zone" {
  count = var.dns_type == "NEW_ROUTE_53" ? 1 : 0
  name  = var.domain
}

# Sync domain name servers with new hosted zone
resource "aws_route53domains_registered_domain" "domain" {
  count       = var.dns_type == "NEW_ROUTE_53" ? 1 : 0
  domain_name = var.domain

  dynamic "name_server" {
    for_each = toset(aws_route53_zone.new_hosted_zone[0].name_servers)
    content {
       name = name_server.value
    }
  }
}

// A-type alias records routing domain traffic to CloudFront
resource "aws_route53_record" "www_to_cloudfront" {
  for_each = local.use_route_53 ? toset(["", "www."]) : []
  zone_id  = local.hosted_zone_id
  name     = "${each.value}${var.domain}"
  type     = "A"
  
  alias {
    name                   = aws_cloudfront_distribution.s3_distribution.domain_name
    zone_id                = aws_cloudfront_distribution.s3_distribution.hosted_zone_id
    evaluate_target_health = false
  }
}

// CNAME records for SSL certificate on www and root
resource "aws_route53_record" "cert_dns_record" {
  for_each = local.use_route_53 ? {
    for options in local.acm_certificate.domain_validation_options:
      options.domain_name => options
  } : {}

  zone_id = local.hosted_zone_id
  name    = each.value.resource_record_name
  type    = each.value.resource_record_type
  ttl     = 300
  records = [each.value.resource_record_value]

  allow_overwrite = true
}

// Validate DNS records
resource "aws_acm_certificate_validation" "cert_validation" {
  for_each                = aws_route53_record.cert_dns_record
  certificate_arn         = local.acm_certificate.arn
  validation_record_fqdns = [each.value.fqdn]
}