locals {
  tags = merge(var.workload_tags, var.common_tags)
}