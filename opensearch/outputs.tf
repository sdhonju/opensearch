output "arn" {
  description = "ARN of the OpenSearch domain"
  value       = aws_opensearch_domain.es.arn
}

output "domain_id" {
  description = "ID of the OpenSearch domain"
  value       = aws_opensearch_domain.es.domain_id
}

output "domain_name" {
  description = "Name of the OpenSearch domain"
  value       = aws_opensearch_domain.es.domain_name
}

output "endpoint" {
  description = "DNS endpoint of the OpenSearch domain"
  value       = aws_opensearch_domain.es.endpoint
}