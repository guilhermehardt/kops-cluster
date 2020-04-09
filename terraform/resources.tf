# Kops store cluster config
resource "aws_s3_bucket" "kops" {
  bucket = "kops-${var.project-name}"
  acl    = "private"

  tags = {
    Name = "kops-${var.project-name}"
  }
}

# Hosted Zone
resource "aws_route53_zone" "main" {
  name = var.main-domain
}

# ACM
resource "aws_acm_certificate" "acm" {
  domain_name               = var.main-domain
  subject_alternative_names = ["*.${var.main-domain}"]

  validation_method = "DNS"

  tags = {
    Environment = var.project-name
  }

  lifecycle {
    create_before_destroy = true
  }
}
resource "aws_route53_record" "route53-acm-record" {
  name    = aws_acm_certificate.acm.domain_validation_options.0.resource_record_name
  type    = aws_acm_certificate.acm.domain_validation_options.0.resource_record_type
  zone_id = aws_route53_zone.main.zone_id
  records = [aws_acm_certificate.acm.domain_validation_options.0.resource_record_value]
  ttl     = 30
}
resource "aws_acm_certificate_validation" "acm-validation" {
  certificate_arn         = aws_acm_certificate.acm.arn
  validation_record_fqdns = ["${aws_route53_record.route53-acm-record.fqdn}"]
}

# Key Pair
# resource "aws_key_pair" "public-key" {
#   key_name   = var.ssh_key_name
#   public_key = var.ssh_public_key
# }

# Route53
# resource "aws_route53_record" "record" {
#   zone_id = data.aws_route53_zone.app-hosted-zone.id
#   name    = var.php-url
#   type    = "A"

#   alias {
#     name                   = aws_alb.alb.dns_name
#     zone_id                = aws_alb.alb.zone_id
#     evaluate_target_health = true
#   }

#   depends_on = [aws_alb.alb]
# }