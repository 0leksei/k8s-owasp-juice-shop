output "public_key" {
  value       = "${local.rsa ? join("", tls_private_key.default_rsa.*.public_key_openssh) : join("", tls_private_key.default_ecdsa.*.public_key_openssh)}"
  description = "Contents of the generated public key"
}

output "key_name" {
  value       = "${aws_key_pair.key_pair.key_name}"
  description = "Name of EC2 key pair"
}

