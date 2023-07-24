locals {
  opensearch_master_password = var.opensearch_master_password == "" ? random_password.master_password.result : var.opensearch_master_password
}

data "aws_caller_identity" "current" {}

data "aws_vpc" "selected" {
  count = var.inside_vpc ? 1 : 0
  id    = var.vpc
}

##########################################
############## Master User ##############
##########################################

# Generate random password if not given when `internal_user_database_enabled` is true
resource "random_password" "master_password" {
  count       = var.internal_user_database_enabled && var.opensearch_master_password == "" ? 1 : 0
  length      = 8
  special     = false
  min_numeric = 1
  min_special = 1
  min_upper   = 1
}

# Store opensearc Master Password in Secrets Manager
module "opensearch_password_secrets_manager" {
  source = "git::ssh://git@gitlab.com/moneygram1/nonworkloads_grp/cloud_eng_grp/mgi_aws_modules_infrastructure.git//tf_1.x/secrets_manager?ref=main"

  secret          = local.opensearch_master_password
  secret_key_name = var.opensearch_master_password_secret_name
  tags            = merge(tomap({"Name"= var.opensearch_master_password_secret_name}), var.tags)
}

# Store opensearc Master Username in Secrets Manager
module "opensearch_username_secrets_manager" {
  source = "git::ssh://git@gitlab.com/moneygram1/nonworkloads_grp/cloud_eng_grp/mgi_aws_modules_infrastructure.git//tf_1.x/secrets_manager?ref=main"  

  secret          = var.opensearch_master_username
  secret_key_name = var.opensearch_master_username_secret_name
  tags            = merge(tomap({"Name"= var.opensearch_master_username_secret_name}), var.tags)
}

##########################################
############## IAM ##############
##########################################

resource "aws_iam_service_linked_role" "es" {
  count            = var.create_linked_role ? 1 : 0
  aws_service_name = var.aws_service_name_for_linked_role
}

resource "time_sleep" "role_dependency" {
  create_duration = "20s"

  triggers = {
    role_arn       = try(aws_iam_role.cognito_es_role[0].arn, null),
    linked_role_id = try(aws_iam_service_linked_role.es[0].id, "11111")
  }
}

##########################################
############## CW Logs ##############
##########################################

resource "aws_cloudwatch_log_group" "cwl_index" {
  name              = "${var.domain_name}/index_slow_logs"
  retention_in_days = var.logging_retention
  tags              = var.tags
}

resource "aws_cloudwatch_log_group" "cwl_search" {
  name              = "${var.domain_name}/search_slow_logs"
  retention_in_days = var.logging_retention
  tags              = var.tags
}

resource "aws_cloudwatch_log_group" "cwl_application" {
  name              = "${var.domain_name}/application_logs"
  retention_in_days = var.logging_retention
  tags              = var.tags
}

resource "aws_cloudwatch_log_group" "cwl_audit" {
  name              = "${var.domain_name}/audit_logs"
  retention_in_days = var.logging_retention
  tags              = var.tags
}



##########################################

##########################################

resource "aws_opensearch_domain" "opensearch" {
  domain_name    = var.opensearch_domain_name
  engine_version = var.engine_version

  advanced_security_options {
    enabled                        = var.advanced_security_options_enabled
    internal_user_database_enabled = var.internal_user_database_enabled
    master_user_options {
      master_user_arn      = var.master_user_arn == "" ? try(aws_iam_role.authenticated[0].arn, null) : var.master_user_arn
      master_user_name     = var.internal_user_database_enabled ? var.master_user_name : ""
      master_user_password = var.internal_user_database_enabled ? local.opensearch_master_password:""//coalesce(var.master_user_password, try(random_password.password[0].result, "")) : ""
    }
  }

  advanced_options = var.advanced_options

  dynamic "vpc_options" {
    for_each = var.inside_vpc ? [1] : []
    content {
      subnet_ids         = var.subnet_ids
      security_group_ids = var.security_group_ids // aws_security_group.es[0].id]
    }
  }

  

  cluster_config {
    instance_count           = try(var.cluster_config["instance_count"], 1)
    instance_type            = var.instance_type
    dedicated_master_enabled = try(var.cluster_config["dedicated_master_enabled"], false)
    dedicated_master_count   = try(var.cluster_config["dedicated_master_count"], 0)
    dedicated_master_type    = try(var.cluster_config["dedicated_master_type"], "t2.small.elasticsearch")
    
    warm_enabled             = try(var.cluster_config["warm_enabled"], false)
    warm_count               = try(var.cluster_config["warm_enabled"], false) ? try(var.cluster_config["warm_count"], null) : null
    warm_type                = try(var.cluster_config["warm_type"], false) ? try(var.cluster_config["warm_type"], null) : null
    zone_awareness_enabled   = try(var.cluster_config["zone_awareness_enabled"], false)
    
    dynamic "zone_awareness_config" {
      for_each = var.availability_zone_count > 1 && var.zone_awareness_enabled ? [true] : []//try(var.cluster_config["zone_awareness_enabled"], false)  ? [1] : []
      content {
        availability_zone_count = try(var.cluster_config["instance_count"], 1)
      }
    }
  }

  encrypt_at_rest {
    enabled    = try(var.encrypt_at_rest["encrypt_at_rest_enabled"], false)
    kms_key_id = try(var.encrypt_at_rest["kms_key_id"], "")
  }

    ebs_options {
    ebs_enabled = var.ebs_enabled
    volume_type = var.volume_type
    volume_size = var.volume_size
    iops        = contains(["io1", "gp3"], var.volume_type) ? var.volume_iops : null
    throughput  = contains(["io1", "gp3"], var.volume_type) ? var.volume_throughput : null
  }


  log_publishing_options {
    enabled                  = var.logging_enabled
    log_type                 = "INDEX_SLOW_LOGS"
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.cwl_index.arn
  }

  log_publishing_options {
    enabled                  = var.logging_enabled
    log_type                 = "SEARCH_SLOW_LOGS"
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.cwl_search.arn
  }

  log_publishing_options {
    enabled                  = var.application_logging_enabled
    log_type                 = "ES_APPLICATION_LOGS"
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.cwl_application.arn
  }

   log_publishing_options {
    enabled                  = var.application_logging_enabled
    log_type                 = "ES_AUDIT_LOGS"
    cloudwatch_log_group_arn = aws_cloudwatch_log_group.cwl_audit.arn
  }




  node_to_node_encryption {
    enabled = var.node_to_node_encryption
  }

  access_policies = var.access_policy == null && var.default_policy_for_fine_grained_access_control ? (<<CONFIG
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": "es:*",
                "Principal": {
                  "AWS": "*"
                  },
                "Effect": "Allow",
                "Resource": "arn:aws:es:${local.region}:${data.aws_caller_identity.current.account_id}:domain/${var.name}/*"
            }
        ]
    }
    CONFIG 
  ) : var.access_policy

  domain_endpoint_options {
    enforce_https                   = var.domain_endpoint_options_enforce_https
    custom_endpoint_enabled         = var.custom_endpoint_enabled
    custom_endpoint                 = var.custom_endpoint_enabled ? var.custom_endpoint : null
    custom_endpoint_certificate_arn = var.custom_endpoint_enabled ? var.custom_endpoint_certificate_arn : null
    tls_security_policy             = var.custom_endpoint_tls_security_policy
  }

  dynamic "cognito_options" {
    for_each = var.cognito_enabled ? [1] : []
    content {
      enabled          = var.cognito_enabled
      user_pool_id     = var.implicit_create_cognito == true ? aws_cognito_user_pool.user_pool[0].id : var.user_pool_id
      identity_pool_id = var.identity_pool_id == "" && var.implicit_create_cognito == true ? aws_cognito_identity_pool.identity_pool[0].id : var.identity_pool_id
      role_arn         = var.implicit_create_cognito == true ? time_sleep.role_dependency.triggers["role_arn"] : var.cognito_role_arn
    }
  }
  tags       = var.tags
  depends_on = [aws_iam_service_linked_role.es[0], time_sleep.role_dependency]
}
