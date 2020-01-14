####################
# Create Bastion host
####################

# Get recent Amazon Linux AMI
data "aws_ami" "amazon_linux" {
  owners      = ["amazon"]
  most_recent = true
  filter {
    name = "name"
    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }
}

# Create Elastic IP for bastion host
resource "aws_eip" "bastion" {
  vpc           = true
  depends_on    = ["aws_instance.bastion"]
  instance      = "${aws_instance.bastion.id}"
  tags          = "${merge(map("Environment", var.environment), var.common_tags)}"
}

# Create TLS SSH key pair and store in SSM. Create EC2 key pair from it
module "ssm_tls_ssh_key_pair" {
  source               = "git::https://github.com/cloudposse/terraform-aws-ssm-tls-ssh-key-pair.git?ref=master"
  #source              = "./modules/ssm_tls_ssh_key_pair"
  name                 = "aleksei-key"
  ssm_path_prefix      = "${var.ssm_path_prefix}"
  ssh_key_algorithm    = "${var.ssh_key_algorithm}"
  ssh_private_key_name = "${var.ssh_private_key_name}"
  ssh_public_key_name  = "${var.ssh_public_key_name}"
  kms_key_id           = "alias/aws/ssm"
}

# Create EC2 key pair from TLS SSH key created above
resource "aws_key_pair" "key_pair" {
  key_name    = "aleksei-ec2-key"
  public_key  = "${module.ssm_tls_ssh_key_pair.public_key}"
}

# Bastion host
resource "aws_instance" "bastion" {
  ami                           = "${data.aws_ami.amazon_linux.id}"
  instance_type                 = "${var.instance_type_bastion}"
  key_name                      = "${aws_key_pair.key_pair.key_name}"
  subnet_id                     = "${element(module.vpc.public_subnets, 0)}"
  vpc_security_group_ids        = ["${aws_security_group.bastion.id}"]
  associate_public_ip_address   = true
  user_data = "${file("files/userdata_bastion.sh")}"
  root_block_device {
        volume_type = "gp2"
        volume_size = 10
  }
  tags = "${merge(map("Environment", var.environment), var.common_tags, map("Bastion", "true"))}"
  volume_tags = "${merge(map("Environment", var.environment), var.common_tags)}"
}
