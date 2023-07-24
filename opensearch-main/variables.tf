##############
# General
##############
variable "account_region" {
  description = "Region where workload is deployed."
  default     = ""
}

variable "common_tags" {
  description = "A map of common tags to add to all resources."
  default     = {}
}

variable "environment_state_bucket" {
  description = "Name of S3 bucket for current environment."
  default     = ""
}

variable "iam_assume_role" {
  description = "ARN of IAM Role in environment account."
  default     = ""
}

variable "iam_assume_role_network" {
  description = "ARN of IAM Role in network account."
  default     = ""
}

variable "vpc_prefix" {
  description = "Path to state file for VPC."
  default     = ""
}

variable "workload_tags" {
  description = "A map of workload tags to add to all resources."
  default     = {}
}

##security group

variable "create_security_group" {
  description = "Whether to create security group and all rules."
  default     = true
}

variable "egress_with_cidr_blocks" {
  description = "Egress Rule"
  type        = list(map(string))
  default     = []
}

# Ingress Rules
variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

variable "baseline_sg" {
  description = "Baseline SG to apply to EC2 instances"
  default     = ""
}

variable "additional_sg" {
  description = "Baseline SG to apply to EC2 instances"
  default     = false
}

variable "additional_sg_name" {
  description = "Baseline SG to apply to EC2 instances"
  default     = ""
}



##Cluster variables

variable "opensearch_domain_name" {
  type        = string
  description = "Name to use for the OpenSearch domain"
}

variable "engine_version" {
  type        = string
  description = "Version of the OpenSearch domain"
  default     = "OpenSearch_1.1"
}

variable "advanced_security_options_enabled" {
  type        = bool
  description = "If advanced security options is enabled."
  default     = false
}

variable "internal_user_database_enabled" {
  type        = bool
  description = "Internal user database enabled. This should be enabled if we want authentication with master username and master password."
  default     = false
}

variable "master_user_name" {
  description = "Master username for accessing OpenSerach."
  type        = string
  default     = "admin"
}

variable "master_password" {
  description = "Master password for accessing OpenSearch. If not specified password will be randomly generated. Password will be stored in AWS `System Manager` -> `Parameter Store` "
  type        = string
  default     = ""
}

variable "master_user_arn" {
  description = "Master user ARN for accessing OpenSearch. If this is set, `advanced_security_options_enabled` must be set to true and  `internal_user_database_enabled` should be set to false."
  type        = string
  default     = ""
}

####### cluster vpc ######

variable "inside_vpc" {
  description = "Openserach inside VPC."
  type        = bool
  default     = true
}


#########################################
############# cluster config ############
#########################################

variable "instance_count" {
  type        = number
  description = "Size of the OpenSearch domain"
  default     = 1
}

variable "instance_type" {
  type        = string
  description = "Instance type to use for the OpenSearch domain"
}

variable "dedicated_master_enabled" {
  type        = bool
  description = "Whether dedicated master nodes are enabled for the domain. Automatically enabled when `warm_enabled = true`"
  default     = false
}

variable "dedicated_master_count" {
  type        = number
  description = "Number of dedicated master nodes in the domain (can be 3 or 5)"
  default     = 3
}

variable "dedicated_master_type" {
  type        = string
  description = "Instance type of the dedicated master nodes in the domain"
  default     = "t3.small.search"
}

variable "warm_enabled" {
  type        = bool
  description = "Whether to enable warm storage"
  default     = false
}

variable "warm_count" {
  type        = number
  description = "Number of warm nodes (2 - 150)"
  default     = 2
}

variable "warm_type" {
  type        = string
  description = "Instance type of the warm nodes"
  default     = "ultrawarm1.medium.search"
}

variable "zone_awareness_enabled" {
  type        = bool
  description = "Whether to enable zone_awareness or not, if not set, multi az is enabled by default and configured through number of instances/subnets available"
  default     = null
}

variable "availability_zone_count" {
  type        = number
  description = "Number of Availability Zones for the domain to use with zone_awareness_enabled.Valid values: 2 or 3. Automatically configured through number of instances/subnets available if not set."
  default     = null
}

variable "encrypt_at_rest_enabled" {
  type        = bool
  description = "Whether to enable encryption at rest for the cluster. Changing this on an existing cluster will force a new resource!"
  default     = true
}

variable "kms_key_id" {
  type        = string
  description = "The KMS key id to encrypt the OpenSearch domain with. If not specified then it defaults to using the `aws/es` service KMS key"
  default     = null
}

variable "ebs_enabled" {
  type        = bool
  description = "EBS enabled"
  default     = true
}

variable "volume_type" {
  type        = string
  description = "EBS volume type to use for the OpenSearch domain"
  default     = "gp3"
}

variable "volume_size" {
  type        = number
  description = "EBS volume size (in GB) to use for the OpenSearch domain"
}

variable "volume_iops" {
  type        = number
  description = "Required if volume_type=\"io1\" or \"gp3\": Amount of provisioned IOPS for the EBS volume"
  default     = 0
}

variable "volume_throughput" {
  description = "Specifies the throughput."
  type        = number
  default     = null
}


######## logging #########

variable "logging_retention" {
  type        = number
  description = "How many days to retain OpenSearch logs in Cloudwatch"
  default     = 30
}

variable "logging_enabled" {
  type        = bool
  description = "Whether to enable OpenSearch slow logs (index & search) in Cloudwatch"
  default     = true
}

variable "application_logging_enabled" {
  type        = bool
  description = "Whether to enable OpenSearch application logs (error) in Cloudwatch"
  default     = false
}

variable "node_to_node_encryption" {
  type        = bool
  description = "Is node to node encryption enabled."
  default     = true
}

######## custom domain endpoints #########

variable "domain_endpoint_options_enforce_https" {
  description = "Enforce https."
  type        = bool
  default     = true
}

variable "custom_endpoint_enabled" {
  description = "If custom endpoint is enabled."
  type        = bool
  default     = true
}

variable "custom_endpoint" {
  type        = string
  description = "The domain name to use as custom endpoint for Elasicsearch"
  default     = null
}

variable "custom_endpoint_certificate_arn" {
  type        = string
  description = "ARN of the ACM certificate to use for the custom endpoint. Required when custom endpoint is set along with enabling `endpoint_enforce_https`"
  default     = null
}

variable "custom_endpoint_tls_security_policy" {
  type        = string
  description = "The name of the TLS security policy that needs to be applied to the HTTPS endpoint. Valid values: `Policy-Min-TLS-1-0-2019-07` and `Policy-Min-TLS-1-2-2019-07`"
  default     = "Policy-Min-TLS-1-2-2019-07"
}

####### cognito ######
variable "cognito_enabled" {
  description = "Cognito authentification enabled for OpenSearch."
  type        = bool
  default     = false
}

######## snapshot #####

variable "snapshot_start_hour" {
  type        = number
  description = "Hour during which an automated daily snapshot is taken of the OpenSearch indices"
  default     = 3
}

variable "s3_snapshots_enabled" {
  type        = bool
  description = "Whether to create a custom snapshot S3 bucket and enable automated snapshots through Lambda"
  default     = false
}

variable "s3_snapshots_lambda_timeout" {
  type        = number
  description = "The execution timeout for the S3 snapshotting Lambda function"
  default     = 180
}

variable "s3_snapshots_schedule_period" {
  type        = number
  description = "Snapshot frequency specified in hours"
  default     = 24
}

variable "s3_snapshots_retention" {
  type        = number
  description = "How many days to retain the OpenSearch snapshots in S3"
  default     = 14
}

variable "s3_snapshots_logs_retention" {
  type        = number
  description = "How many days to retain logs for the S3 snapshot Lambda function"
  default     = 30
}

variable "s3_snapshots_monitoring_sns_topic_arn" {
  type        = string
  description = "ARN for the SNS Topic to send alerts to from the S3 snapshot Lambda function. Enables monitoring of the Lambda function"
  default     = null
}





# DNS

variable "create_a_record" {
  type        = bool
  description = "Create A record for custom domain."
  default     = true
}

variable "domain_name" {
  description = "Name of the hosted zone."
  default     = "aws.moneygram.com"
}

# variable "record_name" {
#   description = "EC2 Server DNS Name."
#   type        =  list
# }

variable "record_type" {
  description = "The record type."
  default     = "CNAME"
}

variable "ttl" {
  description = "Time To Live of the Route53 record."
  default = "300"
}
