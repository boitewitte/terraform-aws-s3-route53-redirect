locals {
  route53 = [
    for zone in var.route53 :
    format(
      "%s.",
      replace(
        zone.zone,
        "/\\.$/",
        ""
      )
    )
  ]
}

resource "aws_route53_zone" "zone" {
  count = var.create_zones && length(local.route53) > 0 ? length(local.route53) : 0

  name = local.route53[count.index].zone
  tags = module.label.tags
}

data "aws_route53_zone" "zone" {
  count = var.create_zones == false && length(local.route53) > 0 ? length(local.route53) : 0

  name = local.route53[count.index].zone
}

locals {
  route53_zones = var.create_zones ? aws_route53_zone.zone[*] : data.aws_route53_zone.zone[*]

  route53_zone_ids = {
    for zone in local.route53_zones :
    zone.name => zone.zone_id
  }
}
