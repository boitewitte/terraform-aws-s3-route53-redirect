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

resource "aws_s3_bucket" "redirect" {
  bucket = module.label.id
  acl    = var.bucket_acl

  website {
    redirect_all_requests_to = format(
      "%s%s",
      var.protocol != null ? local.protocol : "",
      var.target
    )
  }
}
