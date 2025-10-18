// These resources are mutually exclusive.

// (default) var.use_existing_ssl_certificate = false
resource "aws_acm_certificate" "ssl_certificate" {
  depends_on        = [ aws_route53_zone.new_hosted_zone, data.aws_route53_zone.existing_hosted_zone ]
  count             = var.use_existing_ssl_certificate ? 0 : 1
  domain_name       = var.domain
  validation_method = "DNS"

  subject_alternative_names = [
    "*.${var.domain}", // might be able to do *.domain.com, mine is currently www.domain.com
  ]
}

// var.use_existing_ssl_certificate = true
data "aws_acm_certificate" "existing_ssl_certificate" {
  depends_on = [ aws_route53_zone.new_hosted_zone, data.aws_route53_zone.existing_hosted_zone ]
  count      = var.use_existing_ssl_certificate ? 1 : 0
  domain     = var.domain
  statuses   = [ "ISSUED" ]
}