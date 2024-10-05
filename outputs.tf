/*output "bucket_id" {
  value = aws_s3_bucket.ticketea_bucket.id
}*/

output "ticketea_elastic_ip" {
  value       = aws_eip.ticketea_elastic_ip.public_ip
  description = "The Elastic IP address assigned to the instance"
}

output "ticketea_ns" {
  value = aws_route53_zone.ticketea_zone.name_servers
  description = "Servidores de nombres (NS) de la zona hospedada ticketea.me"
}