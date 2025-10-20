output "acm_ssl_certificate_arn" {
  value = var.use_existing_ssl_certificate ? data.aws_acm_certificate.existing_ssl_certificate[0].arn : aws_acm_certificate.ssl_certificate[0].arn
}

output "route_53_hosted_zone_id" {
  value = local.use_route_53 ? local.hosted_zone_id : null
}