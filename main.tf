locals {
  is_valid = (
    var.protocol != null &&
    contains(
      ["https://", "http://"],
      local.protocol
    )
  ) || var.protocol == null
}

module "label" {
  source = "git::https://github.com/cloudposse/terraform-null-label.git"

  attributes  = var.attributes
  context     = var.context
  environment = var.environment
  namespace   = var.namespace
  stage       = var.stage
  tags        = var.tags

  name = var.target
}
