variable "domain" {
  description = "The name of the hosted zone."
}

variable "instance_count" {
  description = "Number of instances to create."
}

variable "name" {
  description = "The name of the record."
  type = list
}

variable "private_zone" {
  description = "Set true for private zone."
  default = "false"
}

variable "records" {
  description = "A string list of records, separated by comma."
  type = list
}

variable "ttl" {
  description = "The TTL of the record."
  default = "30"
}

variable "type" {
  description = "The record type."
  default = "A"
}