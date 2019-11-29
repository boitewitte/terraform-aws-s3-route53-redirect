locals {
  distro_aliases = [
    for record in local.route53_records :
    record.record
  ]
}

resource "aws_cloudfront_distribution" "redirect" {
  comment = "Redirect '${join("', '", local.distro_aliases)}' to: ${local.target}"
  origin {
    domain_name = aws_s3_bucket.redirect.bucket_regional_domain_name
    origin_id   = module.label.id
  }

  enabled = local.is_valid

  aliases = local.distro_aliases

  default_cache_behavior {
    allowed_methods = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods  = ["GET", "HEAD"]

    target_origin_id       = module.label.id
    viewer_protocol_policy = "allow-all"

    forwarded_values {
      query_string = true

      cookies {
        forward = "none"
      }
    }
  }
}
