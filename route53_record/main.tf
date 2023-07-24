data "aws_route53_zone" "this" {
  name         = var.domain
  private_zone = var.private_zone
}

terraform {
  required_providers {
    aws = {
        source  = "hashicorp/aws"
        version = ">= 2.7.0"
    }
  }
}

resource "aws_route53_record" "this" {
  count   = var.instance_count
  name    = var.name[count.index]
  records = split(",", var.records[count.index])
  type    = var.type
  ttl     = var.ttl
  zone_id = data.aws_route53_zone.this.zone_id
}