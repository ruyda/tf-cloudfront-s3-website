output "acm_ssl_certificate_arn" {
  value = module.networking.acm_ssl_certificate_arn
}

output "route_53_hosted_zone_id" {
  value = module.networking.route_53_hosted_zone_id
}