output "acm_ssl_certificate_arn" {
  value = var.use_existing_ssl_certificate ? data.aws_acm_certificate.existing_ssl_certificate[0].arn : aws_acm_certificate.ssl_certificate[0].arn
}