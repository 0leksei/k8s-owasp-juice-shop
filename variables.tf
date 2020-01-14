##################
# Define variables
##################

####################
# AWS Account details
####################
variable "aws_access_key" {
  description = "AWS access key"
  default     = ""
}

variable "aws_secret_key" {
  description = "AWS secret key"
  default     = ""
}

variable "aws_region" {
  description = "AWS region name"
  default     = ""
}

variable "azs" {
  description = "Availability zones in AWS region"
  type        = "list"
  default     = []
}

variable "environment" {
  description = "Environment name"
  default     = ""
}

variable "common_tags" {
  type        = "map"
  description = "Other common tags"
  default = {}
}

####################
## VPC details
####################
variable "vpc_cidr" {
  description = "VPC CIDR block"
  default     = ""
}

variable "private_subnets" {
  description = "Private subnets CIDR blocks"
  type        = "list"
  default     = []
}

variable "public_subnets" {
  description = "Public subnets CIDR blocks"
  type        = "list"
  default     = []
}

####################
## EKS details
####################
variable "cluster_name" {
  description = "EKS cluster name"
  default     = ""
}

variable "api_public_access" {
  description = "Whether public access to AWS EKS Control plane API should be allowed"
  default     = "false"
}

variable "instance_type" {
  description = "EKS worker node instance type"
  default     = ""
}

variable "cidr_blocks_allowed_api" {
  description = "CIDR blocks allowed to access EKS control plane"
  type        = "map"
  default     = {}
}

variable "cidr_blocks_allowed_elb" {
  description = "CIDR blocks allowed to HTTP into ELB"
  type        = "map"
  default     = {}
}

variable "asg_min_size" {
  description   = "Minimum size of autoscaling group for EKS workers"
  default       = ""
}

variable "asg_desired_capacity" {
  description   = "Desired size of autoscaling group for EKS workers"
  default       = ""
}

variable "asg_max_size" {
  description   = "Maximum size of autoscaling group for EKS workers"
  default       = ""
}

variable "local_exec_interpreter" {
  description   = "Command to run for local-exec resources. Must be a shell-style interpreter. On Windows, Git Bash is a good choice"
  default       = ["/bin/sh", "-c"]
}

####################
## Bastion details
####################
variable "instance_type_bastion" {
  description = "EC2 instance type"
  default     = ""
}

variable "ssh_public_key_name" {
  type        = "string"
  description = "SSM Parameter name of the SSH public key"
  default     = "aleksei-ec2-key.pub"
}

variable "ssh_private_key_name" {
  type        = "string"
  description = "SSM Parameter name of the SSH private key"
  default     = "aleksei-ec2-key"
}

variable "ssh_key_algorithm" {
  type        = "string"
  description = "SSH key algorithm to use. Currently-supported values are 'RSA' and 'ECDSA'"
  default     = "RSA"
}

variable "ssm_path_prefix" {
  type        = "string"
  description = "The SSM parameter path prefix"
  default     = "ssh_keys"
}