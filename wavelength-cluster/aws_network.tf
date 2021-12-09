# Create the VPC
resource "aws_vpc" "tf_vpc" {
  cidr_block           = "10.0.0.0/16"
  instance_tenancy     = "default"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "wavelength-vpc"
  }
}

# Create subnets in parent region; coredns and Pixie components run here
resource "aws_subnet" "region_subnets" {
  for_each = var.availability_zones

  vpc_id = aws_vpc.tf_vpc.id

  cidr_block           = each.value.cidr_block
  availability_zone_id = each.value.availability_zone_id

  tags = {
    Name = "wavelength-region-subnet-${each.key}"
  }
}

# Create subnet for each wavelength zone
resource "aws_subnet" "wavelength_subnets" {
  for_each = var.wavelength_zones

  vpc_id = aws_vpc.tf_vpc.id

  cidr_block           = each.value.cidr_block
  availability_zone_id = each.value.availability_zone_id

  tags = {
    Name = "wavelength-edge-subnet-${each.key}"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "tf_internet_gw" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "tf Internet Gateway"
  }
}

# Create Carrier Gateway
resource "aws_ec2_carrier_gateway" "tf_carrier_gateway" {
  vpc_id = aws_vpc.tf_vpc.id
  tags = {
    Name = "tf-carrier-gw"
  }
}