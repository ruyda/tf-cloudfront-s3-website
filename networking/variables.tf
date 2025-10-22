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
  nullable    = true
  description = "the ID assigned to the AWS-managed or custom distribution caching policy"
}

variable "origin_request_policy_id" {
  type        = string
  nullable    = true
  description = "the ID assigned to the AWS-managed or custom origin request policy"
}