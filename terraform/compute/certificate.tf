# -------------------------------------------------------------------
# Certificado ACM — emitido e gerenciado pela AWS (gratuito)
# Validação: DNS — você precisará criar um registro CNAME no seu DNS
# -------------------------------------------------------------------
resource "aws_acm_certificate" "app" {
  domain_name               = var.domain_name
  subject_alternative_names = ["www.${var.domain_name}"]
  validation_method         = "DNS"

  lifecycle { create_before_destroy = true }

  tags = { Name = "zenon-cert" }
}

# -------------------------------------------------------------------
# Após o terraform apply, copie os registros CNAME abaixo e adicione
# no seu provedor de DNS (Registro.br, Cloudflare, GoDaddy, etc.)
# O certificado só será emitido após a validação.
# -------------------------------------------------------------------
output "acm_validation_records" {
  description = "Registros CNAME para validar o certificado no seu DNS"
  value = {
    for dvo in aws_acm_certificate.app.domain_validation_options : dvo.domain_name => {
      name  = dvo.resource_record_name
      type  = dvo.resource_record_type
      value = dvo.resource_record_value
    }
  }
}

output "acm_certificate_arn" {
  description = "ARN do certificado ACM"
  value       = aws_acm_certificate.app.arn
}
