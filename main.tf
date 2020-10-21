data "aws_vpc" "selected" {
  count = var.vpc != "" ? 1 : 0

  tags = {
    Name = var.vpc
  }
}

data "aws_route53_zone" "selected" {
  count = local.is_subdomain ? 1 : 0

  zone_id = var.parent_zone_id
  name    = var.parent_name
  vpc_id  = local.vpc_id
  tags    = var.parent_tags
}

locals {
  name         = local.is_subdomain ? "${var.name}.${var.parent_name}" : var.name
  is_subdomain = var.parent_name != "" || var.parent_zone_id != ""
  vpc_id       = element(concat(data.aws_vpc.selected.*.id, [""]), 0)
  comment      = local.vpc_id == "" ? "${local.name} zone" : "Internal zone for ${var.vpc} (${local.vpc_id})"
}

resource "aws_route53_zone" "default" {
  comment = var.comment != "" ? var.comment : local.comment
  name    = local.name

  dynamic "vpc" {
    for_each = toset(data.aws_vpc.selected.*.id)
    content {
      vpc_id = vpc.value
    }
  }

  tags = var.tags
}

resource "aws_route53_record" "default" {
  count = local.is_subdomain ? 1 : 0

  zone_id = data.aws_route53_zone.selected[0].zone_id
  name    = aws_route53_zone.default.name
  type    = "NS"
  ttl     = var.parent_ttl

  records = [
    aws_route53_zone.default.name_servers[0],
    aws_route53_zone.default.name_servers[1],
    aws_route53_zone.default.name_servers[2],
    aws_route53_zone.default.name_servers[3],
  ]
}
