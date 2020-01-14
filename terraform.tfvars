# AWS details
environment         = "test"
aws_region          = "eu-west-1"

# VPC details
vpc_cidr            = "10.63.0.0/16"
public_subnets      = ["10.63.1.0/24", "10.63.2.0/24", "10.63.3.0/24"]
private_subnets     = ["10.63.11.0/24", "10.63.12.0/24", "10.63.13.0/24"]
azs                 = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]

# Optional tags to apply on all resources
common_tags = {
    "Owner"        = "Aleksei Hodunkov"
    "Duedate"      = "2019-10-31"
}

# Bastion details
instance_type_bastion   = "t3.small"

# CIDR blocks allowed to SSH into EKS control plane
cidr_blocks_allowed_api = {
    "8.8.8.8/32" = "Whitelisted IP 1"
    "4.4.4.4/32" = "Whitelisted IP 2"
}

# CIDR blocks allowed to HTTP into ELB
cidr_blocks_allowed_elb = {
    "8.8.8.8/32" = "Whitelisted IP 1"
    "4.4.4.4/32" = "Whitelisted IP 2"
}

# EKS details
cluster_name            = "aleksei-eks-cluster"
instance_type           = "t3.small"
asg_min_size            = 1
asg_desired_capacity    = 2
asg_max_size            = 3
