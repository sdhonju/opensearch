module "opensearch_security_group" {
  source = ../security_group
  
  create = var.create_security_group
  name   = format("mgi-%s-%s-opensearch-sg",local.tags["application"],local.tags["environment"])
  vpc_id = data.terraform_remote_state.current-vpc.outputs.vpc_id

  # Allow Egress
  egress_with_cidr_blocks = var.egress_with_cidr_blocks

  # Allow Ingress
  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks
  
  tags = local.tags
}

module "opensearch_cluster" {
    source = ../opensearch

    opensearch_domain_name                 = var.opensearch_domain_name
    engine_version                         = var.engine_version
    advanced_security_options_enabled      = var.advanced_security_options_enabled
    internal_user_database_enabled         = true
    opensearch_master_username_secret_name = format("mgi-%s-%s-master-user-name-secret",var.opensearch_domain_name,local.tags["environment"])
    master_user_name                       = var.master_user_name
    opensearch_master_password_secret_name = format("mgi-%s-%s-master-password-secret",var.opensearch_domain_name,local.tags["environment"])
    opensearch_master_password                   = var.master_user_password

    inside_vpc  = true
    vpc = data.terraform_remote_state.current-vpc.outputs.vpc_id
    subnet_ids                  = length(var.subnet_ids) == 0 ? concat(data.terraform_remote_state.current-vpc.outputs.app_private_subnets) : var.subnet_ids
    security_group_ids          = var.additional_sg != true ? [module.opensearch_security_group, var.baseline_sg]:[module.opensearch_security_group.this_security_group_id, var.baseline_sg, var.additional_sg_name]

    
    cluster_config = {
      instance_count            = var.instance_count
      instance_type             = var.instance_type
      dedicated_master_enabled  = var.dedicated_master_enabled
      dedicated_master_count    = var.dedicated_master_count
      dedicated_master_type     = var.dedicated_master_type
      warm_enabled              = var.warm_enabled
      warm_count                = var.warm_enabled ? var.warm_count : null
      warm_type                 = var.warm_enabled ? var.warm_type : null
      zone_awareness_enabled    = var.zone_awareness_enabled
     }

    encrypt_at_rest = {
     encrypt_at_rest_enabled    = var.encrypt_at_rest_enabled
     kms_key_id                 = var.kms_key_id
    }

    volume_size                 = var.volume_size
    volume_iops                 = var.volume_iops

    logging_retention           = var.logging_retention

    custom_endpoint                 = var.custom_endpoint
    custom_endpoint_certificate_arn = var.custom_endpoint_certificate_arn

    

    tags = local.tags

}

module "opensearch_custom_endpoint" {
    source = ../route53_record

    instance_count  = var.custom_endpoint_enabled && var.create_a_record ? 1 : 0
    domain          = var.domain_name
    name            = var.custom_endpoint
    private_zone    = "true"
    records         = [module.opensearch_cluster.opemsearch.endpoint]
    ttl             = var.ttl
    type            = var.record_type

     providers = {
       aws = aws.network
     }
}