variable "dns_type" {
  type        = string
  default     = "NEW_ROUTE_53"
  description = "specify a DNS type; possible values: NEW_ROUTE_53 | EXISTING_ROUTE_53 | NO_ROUTE_53"
}

variable "use_existing_ssl_certificate" {
  type        = bool
  description = "set true to use an existing SSL certificate associated with your domain"
}

variable "domain" {
  type        = string
  description = "the domain (excluding http(s)://www.); example: google.com"
}

variable "distribution_caching_policy_id" {
  type        = string
  default     = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" // AWS-managed CachingDisabled
  description = "the ID assigned to the AWS-managed or custom distribution caching policy"
}

variable "origin_request_policy_id" {
  type        = string
  default     = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf" // AWS-managed CORS-S3Origin
  description = "the ID assigned to the AWS-managed or custom origin request policy"
}