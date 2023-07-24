variable "secret" {
  description = "Specifies text data that you want to encrypt and store in this version of the secret. This is required if secret_binary is not set"
}

variable "secret_key_name" {
  description = "Name of the secret key to be created in secrets manager"
}

variable "tags" {
  description = "Tags which will be applied to all resources that accept them. Tags will also be used to dynamically generate names and extract information about the environment we're deploying into."
  type        = map(string)
}