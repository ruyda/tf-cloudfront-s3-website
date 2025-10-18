variable "domain" {
  type        = string
  description = "the domain (excluding http(s)://www.); example: google.com;"
}

variable "website_contents_path" {
  type        = string
  description = "/path/to/website/directory"
}

variable "use_access_logging" {
  type        = bool
  description = "set false to prevent logging server access events to S3"
}