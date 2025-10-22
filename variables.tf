variable "aws_region" {
  type        = string
  description = "the AWS region to deploy the website infrastructure"
}

variable "dns_type" {
  type        = string
  default     = "NEW_ROUTE_53"
  description = "NEW_ROUTE_53 creates a new hosted zone for a domain registered with Route 53; EXISTING_ROUTE_53 looks up an existing hosted zone associated with your domain; NO_ROUTE_53 omits Route 53 resources. An SSL certificate must be uploaded to ACM regardless of DNS type"
}

variable "use_existing_ssl_certificate" {
  type        = bool
  default     = false
  description = "set true to use an existing SSL certificate associated with your domain"
}

variable "use_access_logging" {
  type        = bool
  default     = true
  description = "set false to prevent logging server access events to S3"
}

variable "domain" {
  type        = string
  description = "the domain (excluding http(s)://www.); example: google.com"
}

variable "distribution_caching_policy_id" {
  type        = string
  nullable    = true
  default     = "4135ea2d-6df8-44a3-9df3-4b5a84be39ad" // AWS-managed CachingDisabled
  description = "the ID assigned to the AWS-managed or custom distribution caching policy"
}

variable "origin_request_policy_id" {
  type        = string
  nullable    = true
  default     = "88a5eaf4-2fd4-4709-b370-b4c650ea3fcf" // AWS-managed CORS-S3Origin
  description = "the ID assigned to the AWS-managed or custom origin request policy"
}

variable "website_contents_path" {
  type        = string
  description = "/path/to/website/directory (excluding trailing slash)"
}