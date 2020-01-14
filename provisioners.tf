##################
# Define provisioning tasks
##################

# Create SSH connection to Bastion and copy kubeconfig to it

# resource "null_resource" "bastion_preparation" {
#   depends_on        = ["module.ssm_tls_ssh_key_pair.key_name"]
#   triggers          = {
#         instance = "${aws_instance.bastion.id}"
#     }
#   provisioner "local-exec" {
#     working_dir = "${path.module}"
#     command     = <<EOT
# 	aws ssm get-parameters --names /ssh_keys/aleksei-ec2-key --with-decryption --query Parameters[0].[Value] --output text > private_key.pem
# 	chmod 400 private_key.pem
# 	EOT
#   }
# }

# resource "null_resource" "bastion_commands" {
#   depends_on     = ["null_resource.bastion_preparation"]
#   triggers       = {
#         instance = "${aws_instance.bastion.id}"
#     }

#   connection {
#     type        = "ssh"
#     user        = "ec2-user"
#     private_key = "${file("./private_key.pem")}"
#     host        = "${aws_eip.bastion.public_ip}"
#   }

#   provisioner "remote-exec" {
#     inline = [
#         "mkdir -p .kube",
# 	"sudo su",
#         "sudo echo \"AWS_ACCESS_KEY_ID=${var.aws_access_key}\" >> /etc/environment",
#         "sudo echo \"AWS_SECRET_ACCESS_KEY=${var.aws_secret_key}\" >> /etc/environment",
# 	"exit",
#     ]
#   }

#   provisioner "file" {
#     source        = "${module.eks-cluster.kubeconfig_filename}"
#     destination   = "~/.kube/config"
#   }
# }
