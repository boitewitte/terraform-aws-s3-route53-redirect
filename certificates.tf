locals {
  certificate_zone_domain_name_splitter = "|&|"
  certificate_domain_names = distinct(
    flatten([
      for record in local.route53_records :
      join(
        local.certificate_zone_domain_name_splitter,
        [
          record.zone,
          length(split(".", record.record)) == 3
          ? record.record
          : format("%s.%s", "*", join(".", slice(split(".", record.record), 1, length(split(".", record.record)))))
        ]
      )
    ])
  )

  certificates = [
    for certificate in local.certificate_domain_names :
    {
      zone        = element(split(local.certificate_zone_domain_name_splitter, certificate), 0)
      domain_name = element(split(local.certificate_zone_domain_name_splitter, certificate), 1)
    }
  ]

  certificate_zone_for_domain_name = {
    for certificate in local.certificates :
    replace(certificate.domain_name, "/\\.$/", "") => certificate.zone
  }

  certificate_domain_name = replace(local.certificates[0].domain_name, "/\\.$/", "")
  subject_alternative_names = [
    for certificate in slice(local.certificates, 1, length(local.certificates)) :
    replace(certificate.domain_name, "/\\.$/", "")
  ]
}

resource "aws_acm_certificate" "certificates" {
  count = var.create_certificates ? 1 : 0

  domain_name               = local.certificate_domain_name
  subject_alternative_names = local.subject_alternative_names

  validation_method = "DNS"

  tags = module.label.tags

  provider = aws.cloudfront_cert
}

locals {
  certificate_records = flatten([
    for certificate in aws_acm_certificate.certificates :
    [
      for record in certificate.domain_validation_options :
      {
        name  = record.resource_record_name
        type  = record.resource_record_type
        value = record.resource_record_value
        zone_id = lookup(
          local.route53_zone_ids,
          lookup(local.certificate_zone_for_domain_name, record.domain_name, ""),
          ""
        )
      }
      if lookup(local.route53_zone_ids, lookup(local.certificate_zone_for_domain_name, record.domain_name, ""), "") != ""
    ]
  ])
}
