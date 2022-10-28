resource "aws_instance" "this" {
  ami           = var.ami
  instance_type = var.instance_type

  subnet_id              = var.subnet_id
  vpc_security_group_ids = var.vpc_security_group_ids

  key_name = var.key_name

  disable_api_termination = var.disable_api_termination
  disable_api_stop        = var.disable_api_stop
}

