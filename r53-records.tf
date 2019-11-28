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

resource "aws_route53_record" "record" {
  count = local.is_valid && length(local.route53_records)

  zone_id = lookup(
    local.route53_zone_ids,
    local.route53_records[count.index].zone
  )

  name = local.route53_records[count.index].record
  type = "A"

  alias {
    name                   = aws_s3_bucket.redirect[0].bucket_domain_name
    zone_id                = aws_s3_bucket.redirect[0].hosted_zone_id
    evaluate_target_health = false
  }
}
