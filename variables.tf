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

variable "website_contents_path" {
  type        = string
  description = "/path/to/website/directory (excluding trailing slash)"
}