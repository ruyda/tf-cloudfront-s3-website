module "s3_static_website" {
  source                = "./s3-static-website"
  domain                = var.domain
  website_contents_path = var.website_contents_path
  use_access_logging    = var.use_access_logging
}

module "networking" {
  depends_on                     = [ module.s3_static_website ]
  source                         = "./networking"
  domain                         = var.domain
  dns_type                       = var.dns_type
  use_existing_ssl_certificate   = var.use_existing_ssl_certificate
  distribution_caching_policy_id = var.distribution_caching_policy_id
  origin_request_policy_id       = var.origin_request_policy_id
}