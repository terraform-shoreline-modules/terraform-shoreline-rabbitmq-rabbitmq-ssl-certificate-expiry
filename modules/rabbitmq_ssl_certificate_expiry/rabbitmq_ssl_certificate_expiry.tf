resource "shoreline_notebook" "rabbitmq_ssl_certificate_expiry" {
  name       = "rabbitmq_ssl_certificate_expiry"
  data       = file("${path.module}/data/rabbitmq_ssl_certificate_expiry.json")
  depends_on = [shoreline_action.invoke_ssl_info,shoreline_action.invoke_generate_ssl_cert]
}

resource "shoreline_file" "ssl_info" {
  name             = "ssl_info"
  input_file       = "${path.module}/data/ssl_info.sh"
  md5              = filemd5("${path.module}/data/ssl_info.sh")
  description      = "Verify RabbitMQ SSL configuration"
  destination_path = "/tmp/ssl_info.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "generate_ssl_cert" {
  name             = "generate_ssl_cert"
  input_file       = "${path.module}/data/generate_ssl_cert.sh"
  md5              = filemd5("${path.module}/data/generate_ssl_cert.sh")
  description      = "Generate a new SSL certificate with a valid expiration date and update it in the RabbitMQ configuration."
  destination_path = "/tmp/generate_ssl_cert.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_ssl_info" {
  name        = "invoke_ssl_info"
  description = "Verify RabbitMQ SSL configuration"
  command     = "`chmod +x /tmp/ssl_info.sh && /tmp/ssl_info.sh`"
  params      = []
  file_deps   = ["ssl_info"]
  enabled     = true
  depends_on  = [shoreline_file.ssl_info]
}

resource "shoreline_action" "invoke_generate_ssl_cert" {
  name        = "invoke_generate_ssl_cert"
  description = "Generate a new SSL certificate with a valid expiration date and update it in the RabbitMQ configuration."
  command     = "`chmod +x /tmp/generate_ssl_cert.sh && /tmp/generate_ssl_cert.sh`"
  params      = ["RABBITMQ_CONFIG_FILE","NEW_CERTIFICATE_NAME","NEW_CERTIFICATE_EXPIRY"]
  file_deps   = ["generate_ssl_cert"]
  enabled     = true
  depends_on  = [shoreline_file.generate_ssl_cert]
}

