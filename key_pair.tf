resource "tls_private_key" "terraform-private-key" {
  algorithm = local.key_pair_options.tls_private_key.algorithm
  rsa_bits  = local.key_pair_options.tls_private_key.rsa_bits
}

resource "aws_key_pair" "terraform-elasticsearch-key-pair" {
  provider   = aws.main
  key_name   = local.elasticsearch_options.key_name
  public_key = tls_private_key.terraform-private-key.public_key_openssh

}

resource null_resource "terraform-elasticsearch-private-key-file" {
  provisioner "local-exec" {
    command = "echo '${tls_private_key.terraform-private-key.private_key_pem}' > ~/.ssh/${local.environment_name}-elasticsearch.pem | chmod 600 ~/.ssh/${local.environment_name}-elasticsearch.pem"
  }
}