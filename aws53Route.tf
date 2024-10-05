resource "aws_route53_zone" "ticketea_zone" {
  name = "ticketea.me"
}

resource "aws_route53_record" "ticketea_root" {
  zone_id = aws_route53_zone.ticketea_zone.zone_id
  name    = "ticketea.me"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.ticketea_elastic_ip.public_ip]
}

resource "aws_route53_record" "www_ticketea" {
  zone_id = aws_route53_zone.ticketea_zone.zone_id
  name    = "www.ticketea.me"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.ticketea_elastic_ip.public_ip]
}

resource "aws_route53_record" "api_ticketea" {
  zone_id = aws_route53_zone.ticketea_zone.zone_id
  name    = "api.ticketea.me"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.ticketea_elastic_ip.public_ip]
}

resource "aws_route53_record" "www_api_ticketea" {
  zone_id = aws_route53_zone.ticketea_zone.zone_id
  name    = "www.api.ticketea.me"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.ticketea_elastic_ip.public_ip]
}