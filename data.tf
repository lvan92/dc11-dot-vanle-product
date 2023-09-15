data "aws_vpc" "selected" {
  filter {
    name   = "tag:name"
    values = [ "Networking VPC" ]
  }
}

data "aws_subnets" "vpc" {
  filter {
    name = "vpc-id"
    values = [ data.aws_vpc.selected.id ]
  }
}

data "aws_subnet" "all" {
  for_each = toset(data.aws_subnets.vpc.ids)
  id       = each.value
}

data "aws_ami" "vitrual" {
  most_recent = true
  filter {
    name = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
  }
  filter {
    name = "virtualization-type"
    values = [ "hvm" ]
  }
}

locals {
  config_file_name      = "${terraform.workspace}.tfvars"
  full_config_file_path = "variables/${local.config_file_name}"
  vars                  = yamldecode(file(local.full_config_file_path))
}

locals {
  subnet_private_ids = [
    for s in data.aws_subnet.all : s.id
    if can(regex("^Private Subnet", s.tags.name))
  ]

  subnet_private = [
    for s in data.aws_subnet.all : s
    if can(regex("^Private Subnet", s.tags.name))
  ]

  subnet_public_ids = [
    for s in data.aws_subnet.all : s.id
    if can(regex("^Public Subnet", s.tags.name))
  ]

  subnet_public = [
    for s in data.aws_subnet.all : s
    if can(regex("^Public Subnet", s.tags.name))
  ]
}