##################
# Create AWS VPC
##################
module "vpc" {
  source                = "terraform-aws-modules/vpc/aws"
  version               = "2.17.0"
  name                  = "aleksei-vpc"
  cidr                  = "${var.vpc_cidr}"
  azs                   = "${var.azs}"
  private_subnets       = "${var.private_subnets}"
  public_subnets        = "${var.public_subnets}"
  enable_dns_hostnames  = true
  enable_dns_support    = true
  enable_nat_gateway    = true
  single_nat_gateway    = true

  public_subnet_tags      = {
    Tier                                        = "public"
    "kubernetes.io/role/elb"                    = "1"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  private_subnet_tags = {
    Tier                                        = "private"
    "kubernetes.io/cluster/${var.cluster_name}" = "shared"
  }

  tags = "${merge(map("Environment", var.environment), var.common_tags, map("kubernetes.io/cluster/${var.cluster_name}", "shared"))}"
}

##################
# Create AWS EKS cluster
##################
module "eks-cluster" {
  source                            = "terraform-aws-modules/eks/aws"
  version                           = "6.0.2"
  cluster_name                      = "${var.cluster_name}"
  subnets                           = "${module.vpc.private_subnets}"
  vpc_id                            = "${module.vpc.vpc_id}"
  local_exec_interpreter            = "${var.local_exec_interpreter}"
  manage_aws_auth                   = true
  cluster_endpoint_private_access   = true
  cluster_endpoint_public_access    = "${var.api_public_access}"
  worker_groups = [
    {
      instance_type         = "${var.instance_type}"
      asg_max_size          = "${var.asg_max_size}"
      asg_desired_capacity  = "${var.asg_desired_capacity}"
      asg_min_size          = "${var.asg_min_size}"
      key_name              = "${aws_key_pair.key_pair.key_name}"
      tags = [{
        key                 = "Owner"
        value               = "Aleksei Hodunkov"
        propagate_at_launch = true
      },
      {
        key                 = "Duedate"
        value               = "2019-10-31"
        propagate_at_launch = true
      }]
    }
  ]

  tags = "${merge(map("Environment", var.environment), var.common_tags)}"
}
