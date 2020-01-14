##################
# Define security groups
##################

# Allow access to EKS control plane from bastion
resource "aws_security_group_rule" "access_api" {
  type                      = "ingress"
  from_port                 = "443"
  to_port                   = "443"
  protocol                  = "tcp"
  security_group_id         = "${module.eks-cluster.cluster_security_group_id}"
  source_security_group_id  = "${aws_security_group.bastion.id}"
  description               = "Access to EKS control plane from bastion"
}

# Bastion security group
resource "aws_security_group" "bastion" {
  name        = "aleksei-bastion"
  description = "Access to Bastion"
  vpc_id      = "${module.vpc.vpc_id}"
  tags = "${merge(map("Environment", var.environment), var.common_tags)}"
}

## Bastion securty group egress rule
resource "aws_security_group_rule" "bastion_egress" {
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  security_group_id = "${aws_security_group.bastion.id}"
}

## Bastion security group rules to allow access from IP ranges
resource "aws_security_group_rule" "access_bastion" {
  count             = "${length(var.cidr_blocks_allowed_api)}"
  type              = "ingress"
  from_port         = "22"
  to_port           = "22"
  protocol          = "tcp"
  security_group_id = "${aws_security_group.bastion.id}"
  cidr_blocks       = ["${element(keys(var.cidr_blocks_allowed_api), count.index)}"]
  description       = "${var.cidr_blocks_allowed_api["${element(keys(var.cidr_blocks_allowed_api), count.index)}"]}"
}