# Store the random string in a local variable for later use
locals {
  secret_key_suffix_val = random_string.secret_key_suffix.result
}

# Random string to use as a suffix for the secret name
resource "random_string" "secret_key_suffix" {
  length  = 5
  special = false
}

# Create a secrets manager secret key
resource "aws_secretsmanager_secret" "secret_key" {
  name = format("%s-%s",var.secret_key_name,local.secret_key_suffix_val)
  tags = merge(tomap({"Name"= var.secret_key_name}), var.tags)  
}

# Store the secret in the secrets manager
resource "aws_secretsmanager_secret_version" "secret_version" {
  secret_id     = aws_secretsmanager_secret.secret_key.id
  secret_string = var.secret
}