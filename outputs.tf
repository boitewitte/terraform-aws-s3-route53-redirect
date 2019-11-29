output "is_valid" {
  value = local.is_valid
}

output "bucket" {
  value = local.is_valid ? {
    id                          = aws_s3_bucket.redirect[0].id
    bucket                      = aws_s3_bucket.redirect[0].bucket
    arn                         = aws_s3_bucket.redirect[0].arn
    bucket_domain_name          = aws_s3_bucket.redirect[0].bucket_domain_name
    bucket_regional_domain_name = aws_s3_bucket.redirect[0].bucket_regional_domain_name
    hosted_zone_id              = aws_s3_bucket.redirect[0].hosted_zone_id
    region                      = aws_s3_bucket.redirect[0].region
    website_endpoint            = aws_s3_bucket.redirect[0].website_endpoint
    website_domain              = aws_s3_bucket.redirect[0].website_domain
  } : {}
}

output "records" {
  value = aws_route53_record.record
}

output "zones" {
  value = local.route53_zones
}

output "certificates" {
  value = aws_acm_certificate.certificates
}

output "certificate_records" {
  value = local.certificate_records
}

# output "certificates" {
#   value = local.certificates
# }

# output "certificate_zone_for_domain_name" {
#   value = local.certificate_zone_for_domain_name
# }

# output "aws_acm_certificate" {
#   value = local.aws_acm_certificate
# }
