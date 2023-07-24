##################################
# Get ID of created Security Group
##################################
locals {
  this_sg_id = var.create ? concat(aws_security_group.this.*.id, aws_security_group.this_name_prefix.*.id, [""])[0] : var.security_group_id
}

##########################
# Security group with name
##########################
resource "aws_security_group" "this" {
  count = var.create && ! var.use_name_prefix ? 1 : 0

  name        = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(var.tags, tomap({"Name" = format("%s", var.name)}))
}

#################################
# Security group with name_prefix
#################################
resource "aws_security_group" "this_name_prefix" {
  count = var.create && var.use_name_prefix ? 1 : 0

  name_prefix = var.name
  description = var.description
  vpc_id      = var.vpc_id

  tags = merge(var.tags, tomap({"Name" = format("%s", var.name)}))

  lifecycle {
    create_before_destroy = true
  }
}

############
# Ingress
############
# Security group rules with "cidr_blocks" and it uses list of rules names
resource "aws_security_group_rule" "ingress_rules" {
  count = var.create ? length(var.ingress_rules) : 0

  security_group_id = local.this_sg_id
  type              = "ingress"

  cidr_blocks      = var.ingress_cidr_blocks
  description      = var.rules[var.ingress_rules[count.index]][3]
  prefix_list_ids  = var.ingress_prefix_list_ids

  from_port = var.rules[var.ingress_rules[count.index]][0]
  to_port   = var.rules[var.ingress_rules[count.index]][1]
  protocol  = var.rules[var.ingress_rules[count.index]][2]
}

# Security group rules with "cidr_blocks", but without "ipv6_cidr_blocks", "source_security_group_id" and "self"
resource "aws_security_group_rule" "ingress_with_cidr_blocks" {
  count = var.create ? length(var.ingress_with_cidr_blocks) : 0

  security_group_id = local.this_sg_id
  type              = "ingress"

  cidr_blocks = split(
    ",",
    lookup(
      var.ingress_with_cidr_blocks[count.index],
      "cidr_blocks",
      join(",", var.ingress_cidr_blocks),
    ),
  )
  prefix_list_ids = var.ingress_prefix_list_ids
  description = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "description",
    "Ingress Rule",
  )

  from_port = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "from_port",
    var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")][0],
  )
  to_port = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "to_port",
    var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")][1],
  )
  protocol = lookup(
    var.ingress_with_cidr_blocks[count.index],
    "protocol",
    var.rules[lookup(var.ingress_with_cidr_blocks[count.index], "rule", "_")][2],
  )
}

# Security group rules with "self", but without "cidr_blocks" and "source_security_group_id"
resource "aws_security_group_rule" "ingress_with_self" {
  count = var.create ? length(var.ingress_with_self) : 0

  security_group_id = local.this_sg_id
  type              = "ingress"

  self             = lookup(var.ingress_with_self[count.index], "self", true)
  prefix_list_ids  = var.ingress_prefix_list_ids
  description      = lookup(var.ingress_with_self[count.index], "description", "Ingress Rule")

  from_port = lookup(var.ingress_with_self[count.index], "from_port", element(var.rules[lookup(var.ingress_with_self[count.index], "rule", "_")], 0))
  to_port   = lookup(var.ingress_with_self[count.index], "to_port", element(var.rules[lookup(var.ingress_with_self[count.index], "rule", "_")], 1))
  protocol  = lookup(var.ingress_with_self[count.index], "protocol", element(var.rules[lookup(var.ingress_with_self[count.index], "rule", "_")], 2))
}

# Security group rules with "source_security_group_id", but without "cidr_blocks" and "self"
resource "aws_security_group_rule" "ingress_with_source_security_group_id" {
  count = var.create ? length(var.ingress_with_source_security_group_id) : 0

  security_group_id =local.this_sg_id
  type              = "ingress"

  source_security_group_id = lookup(var.ingress_with_source_security_group_id[count.index], "source_security_group_id")
  prefix_list_ids          = var.ingress_prefix_list_ids
  description              = lookup(var.ingress_with_source_security_group_id[count.index], "description", "Ingress Rule")

  from_port = lookup(var.ingress_with_source_security_group_id[count.index], "from_port", element(var.rules[lookup(var.ingress_with_source_security_group_id[count.index], "rule", "_")], 0))
  to_port   = lookup(var.ingress_with_source_security_group_id[count.index], "to_port", element(var.rules[lookup(var.ingress_with_source_security_group_id[count.index], "rule", "_")], 1))
  protocol  = lookup(var.ingress_with_source_security_group_id[count.index], "protocol", element(var.rules[lookup(var.ingress_with_source_security_group_id[count.index], "rule", "_")], 2))
}

##################
# End of Ingress
##################

##########
# Egress 
##########
# Security group rules with "cidr_blocks" and it uses list of rules names
 resource "aws_security_group_rule" "egress_rules" {
   count = var.create ? length(var.egress_rules) : 0

   security_group_id = local.this_sg_id
   type              = "egress"

   cidr_blocks      = var.egress_cidr_blocks
   description      = var.rules[var.egress_rules[count.index]][3]
   prefix_list_ids  = var.egress_prefix_list_ids
  
   from_port = var.rules[var.egress_rules[count.index]][0]
   to_port   = var.rules[var.egress_rules[count.index]][1]
   protocol  = var.rules[var.egress_rules[count.index]][2]
 }

# # Security group rules with "cidr_blocks", but without "ipv6_cidr_blocks", "source_security_group_id" and "self"
 resource "aws_security_group_rule" "egress_with_cidr_blocks" {
   count = var.create ? length(var.egress_with_cidr_blocks) : 0

   security_group_id = local.this_sg_id
   type              = "egress"

   cidr_blocks = split(
     ",",
     lookup(
       var.egress_with_cidr_blocks[count.index],
       "cidr_blocks",
       join(",", var.egress_cidr_blocks),
     ),
   )
   prefix_list_ids = var.egress_prefix_list_ids
   description = lookup(
     var.egress_with_cidr_blocks[count.index],
     "description",
     "Egress Rule",
   )

   from_port = lookup(
     var.egress_with_cidr_blocks[count.index],
     "from_port",
     var.rules[lookup(var.egress_with_cidr_blocks[count.index], "rule", "_")][0],
   )
   to_port = lookup(
     var.egress_with_cidr_blocks[count.index],
     "to_port",
     var.rules[lookup(var.egress_with_cidr_blocks[count.index], "rule", "_")][1],
   )
   protocol = lookup(
     var.egress_with_cidr_blocks[count.index],
     "protocol",
     var.rules[lookup(var.egress_with_cidr_blocks[count.index], "rule", "_")][2],
   )
 }

#################
# End of Egress
#################