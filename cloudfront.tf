locals {
  distro_aliases = [
    for record in local.route53_records :
    record.record
  ]
}

resource "aws_cloudfront_distribution" "redirect" {
  count = length(aws_s3_bucket.redirect) == 1 ? 1 : 0

  enabled = local.is_valid

  aliases     = local.distro_aliases
  comment     = "Redirect '${join("', '", local.distro_aliases)}' to: ${local.target}"
  price_class = var.cloudfront_price_class

  origin {
    domain_name = aws_s3_bucket.redirect[0].bucket_regional_domain_name
    origin_id   = module.label.id
  }

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

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  viewer_certificate {
    # cloudfront_default_certificate = true
    acm_certificate_arn = aws_acm_certificate.certificates[0].arn
    ssl_support_method  = var.cloudfront_ssl_support_method
  }

  depends_on = ["aws_route53_record.cert_validation"]
}
