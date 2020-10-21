output "name" {
  value = aws_route53_zone.default.name
}

output "name_servers" {
  value = aws_route53_zone.default.name_servers
}

output "vpc_id" {
  value = element(concat(data.aws_vpc.selected.*.id, [""]), 0)
}

output "zone_id" {
  value = aws_route53_zone.default.zone_id
}
