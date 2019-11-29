# ##### #
# LABEL #
# ##### #

variable "context" {
  type = object({
    namespace           = string
    environment         = string
    stage               = string
    name                = string
    enabled             = bool
    delimiter           = string
    attributes          = list(string)
    label_order         = list(string)
    tags                = map(string)
    additional_tag_map  = map(string)
    regex_replace_chars = string
  })
  default = {
    namespace           = ""
    environment         = ""
    stage               = ""
    name                = ""
    enabled             = true
    delimiter           = ""
    attributes          = []
    label_order         = []
    tags                = {}
    additional_tag_map  = {}
    regex_replace_chars = ""
  }
  description = "Default context to use for passing state between label invocations"
}

variable "namespace" {
  type        = string
  default     = ""
  description = "Namespace, which could be your organization name or abbreviation, e.g. 'eg' or 'cp'"
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment, e.g. 'prod', 'staging', 'dev', 'pre-prod', 'UAT'"
}

variable "stage" {
  type        = string
  default     = ""
  description = "Stage, e.g. 'prod', 'staging', 'dev', OR 'source', 'build', 'test', 'deploy', 'release'"
}

variable "name" {
  type        = string
  description = "The name"
  default     = ""
}

variable "attributes" {
  type        = list(string)
  default     = []
  description = "Additional attributes (e.g. `1`)"
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags (e.g. `map('BusinessUnit','XYZ')`"
}


# ############# #
# CONFIGURATION #
# ############# #

variable "create_zones" {
  type        = bool
  description = "Create Route53 zones"
  default     = true
}

variable "route53" {
  type = list(
    object({
      zone       = string
      subdomains = list(string)
    })
  )

}

variable "create_certificates" {
  type        = bool
  description = "Create certificates for the Cloudfront Distribution"
  default     = true
}

variable "cloudfront_price_class" {
  type        = string
  description = "The price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100"
  default     = "PriceClass_100"
}

variable "bucket_acl" {
  type        = string
  description = "The Canned ACL for the Bucket"
  default     = "public-read"
}

variable "protocol" {
  type        = string
  description = "Target protocol"
  default     = null
}

variable "target" {
  type        = string
  description = "Target Hostname or bucket name"
}
