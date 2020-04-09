output "domain-ns" {
  value = aws_route53_zone.main.name_servers
}

output "hostedzone-id" {
  value = aws_route53_zone.main.zone_id
}

output "vpc-id" {
  value = aws_vpc.main.id
}

output "public-subnets" {
  value = join(",", aws_subnet.public-subnets.*.id)
}
