locals {
  protocol = format(
    "%s://",
    replace(
      var.protocol != null ? var.protocol : "",
      "/://$/",
      ""
    )
  )
}

locals {
  target = format(
    "%s%s",
    var.protocol != null ? local.protocol : "",
    var.target
  )
}

resource "aws_s3_bucket" "redirect" {
  count = local.is_valid ? 1 : 0

  bucket = module.label.id
  acl    = var.bucket_acl

  website {
    redirect_all_requests_to = local.target
  }
}
