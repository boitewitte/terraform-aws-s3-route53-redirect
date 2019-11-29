locals {
  route53_records = flatten([
    for zone in var.route53 :
    [
      for subdomain in zone.subdomains :
      {
        zone = format(
          "%s.",
          replace(
            zone.zone,
            "/\\.$/",
            ""
          )
        )
        record = join(
          ".",
          compact([
            subdomain,
            format(
              "%s.",
              replace(
                zone.zone,
                "/\\.$/",
                ""
              )
            )
          ])
        )
      }
    ]
  ])
}

# resource "aws_route53_record" "record" {
#   count = local.is_valid && length(aws_s3_bucket.redirect) == 1 && length(aws_cloudfront_distribution.redirect) == 1 ? length(local.route53_records) : 0

#   zone_id = lookup(
#     local.route53_zone_ids,
#     local.route53_records[count.index].zone
#   )

#   name = local.route53_records[count.index].record
#   type = "A"

#   alias {
#     # name                   = aws_s3_bucket.redirect[0].website_domain
#     # zone_id                = aws_s3_bucket.redirect[0].hosted_zone_id
#     # evaluate_target_health = false
#     name                   = aws_cloudfront_distribution.redirect[0].domain_name
#     zone_id                = aws_cloudfront_distribution.redirect[0].hosted_zone_id
#     evaluate_target_health = false
#   }
# }

locals {
  cert_validation_record_names = distinct(local.certificate_records[*].name)

  cert_validation_records = [
    for name in local.cert_validation_record_names :
    {
      zone_id = element([
        for record in local.certificate_records :
        record.zone_id
        if record.name == name
      ], 0)
      type = element([
        for record in local.certificate_records :
        record.type
        if record.name == name
      ], 0)
      records = distinct([
        for record in local.certificate_records :
        record.value
        if record.name == name
      ])
    }
  ]
}

resource "aws_route53_record" "cert_validation" {
  count = length(local.cert_validation_records)

  zone_id = local.cert_validation_records[count.index].zone_id
  name    = local.cert_validation_records[count.index].name
  type    = local.cert_validation_records[count.index].type
  records = local.cert_validation_records[count.index].records
  ttl     = 300
}
