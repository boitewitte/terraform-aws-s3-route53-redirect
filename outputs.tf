output "is_valid" {
  value = local.is_valid
}

output "bucket" {
  value = local.is_valid ? aws_s3_bucket.redirect[0] : {}
}

output "records" {
  value = aws_route53_record.record
}

output "zones" {
  value = local.route53_zones
}
