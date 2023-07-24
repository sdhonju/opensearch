create_security_group       = true


##opensearch cluster
opensearch_domain_name        = "osearch-test"
engine_version                = "OpenSearch_2.7"
advanced_security_options_enabled = true
master_user_name              = "test-opensearch"
master_user_password          = ""                //[leave empty]

instance_count                = 3
instance_type                 = "r6g.2xlarge.search"
dedicated_master_enabled      = true
dedicated_master_count        = 3
dedicated_master_type         = "c6g.large.search"
zone_awareness_enabled        = true


kms_key_id                      = "kms key arn"
volume_size                     = 256
volume_iops                     = 6000
logging_retention               = 7


custom_endpoint                 = "opensearchtesturl"
custom_endpoint_certificate_arn = "cert arn"



########
# Tags
########
workload_tags = {
  application       = "openmsearch"
  environment       = "sandbox"
  loc_code          = "aws_region"
  pci_compliance    = "no"
}