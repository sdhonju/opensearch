########################################
# Security Group - Common Variables
########################################
variable "create" {
  description = "Whether to create security group and all rules"
  default     = true
}

variable "description" {
  description = "Description of security group"
  default     = "Security Group managed by Terraform"
}

variable "name" {
  description = "Name of security group"
}

variable "security_group_id" {
  description = "ID of existing security group whose rules we will manage"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  default     = {}
}

variable "use_name_prefix" {
  description = "Whether to use name_prefix or fixed name. Should be true to able to update security group name after initial creation"
  default     = true
}

variable "vpc_id" {
  description = "ID of the VPC where to create security group"
}

##########
# Ingress
##########
variable "ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  type        = list(string)
  default     = []
}

variable "ingress_prefix_list_ids" {
  description = "List of prefix list IDs (for allowing access to VPC endpoints) to use on all ingress rules"
  type        = list(string)
  default     = []
}

variable "ingress_rules" {
  description = "List of ingress rules to create by name"
  type        = list(string)
  default     = []
}

variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

variable "ingress_with_self" {
  description = "List of ingress rules to create where 'self' is defined"
  default     = []
}

variable "ingress_ipv6_cidr_blocks" {
  description = "List of IPv6 CIDR ranges to use on all ingress rules"
  default     = []
}

variable "ingress_with_source_security_group_id" {
  description = "List of ingress rules to create where 'source_security_group_id' is used"
  type        = list(map(string))
  default     = []
}

#########
# Egress
#########
variable "egress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all egress rules"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "egress_prefix_list_ids" {
  description = "List of prefix list IDs (for allowing access to VPC endpoints) to use on all egress rules"
  type        = list(string)
  default     = []
}

variable "egress_rules" {
  description = "List of egress rules to create by name"
  type        = list(string)
  default     = []
}

variable "egress_with_cidr_blocks" {
  description = "List of egress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}