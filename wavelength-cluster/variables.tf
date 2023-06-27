variable "profile" {
  type        = string
  description = "AWS Credentials Profile to use"
  default     = "default"
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "This is the AWS region."
}

variable "worker_key_name" {
  type        = string
  default     = "test_key"
  description = "This is your EC2 key name."
}

variable "cluster_name" {
  type    = string
  default = "wavelength-test"
}

# We use availability_zone_id for zone creation, and availability_zone for pod affinity
variable "wavelength_zones" {
  description = "This is the Wavelength Zone deployment metadata for your VPC, including Availability Zone ID, CIDR range per WLZ, NodePort, and number of worker nodes."
  default = {
    nyc = {
      availability_zone    = "us-east-1-wl1-nyc-wlz-1",
      availability_zone_id = "use1-wl1-nyc-wlz1",
      worker_nodes         = 1,
      cidr_block           = "10.0.10.0/24"
      nodeport_offset      = 30100
    },
    bos = {
      availability_zone    = "us-east-1-wl1-bos-wlz-1",
      availability_zone_id = "use1-wl1-bos-wlz1",
      worker_nodes         = 1,
      cidr_block           = "10.0.11.0/24"
      nodeport_offset      = 30200
    },
    # was = {
    #   availability_zone = "us-east-1-wl1-was-wlz-1",
    #   availability_zone_id = "use1-wl1-was-wlz1",
    #   worker_nodes = 2,
    #   cidr_block = "10.0.12.0/24"
    #   nodeport_offset = 30300
    # },
    # atl = {
    #   availability_zone = "us-east-1-wl1-atl-wlz-1",
    #   availability_zone_id = "use1-wl1-atl-wlz1",
    #   worker_nodes = 2,
    #   cidr_block = "10.0.13.0/24"
    #   nodeport_offset = 30400
    # },
    # mia = {
    #   availability_zone = "us-east-1-wl1-mia-wlz-1",
    #   availability_zone_id = "use1-wl1-mia-wlz1",
    #   worker_nodes = 2,
    #   cidr_block = "10.0.14.0/24"
    #   nodeport_offset = 30500
    # },
  }
}

variable "availability_zones" {
  description = "This is the Availability Zone (parent region) deployment metadata for your VPC, including Availability Zone and CIDR range for each AZ."
  default = {
    az1 = {
      availability_zone_id = "use1-az1"
      cidr_block           = "10.0.1.0/24"
    },
    az2 = {
      availability_zone_id = "use1-az2"
      cidr_block           = "10.0.2.0/24"
    },
    # use1-az3 had capacity issues at time of testing
    # az3 = {
    #   availability_zone_id = "use1-az3"
    #   cidr_block = "10.0.23.0/24"
    # },
  }
}

variable "node_group_s3_bucket_url" {
  type        = string
  default     = "<YOUR S3 BUCKET URL>/wlz-eks-node-group.yaml"
  description = "This is the S3 object URL of the EKS node group with auto-attached Carrier IPs."
}

variable "worker_volume_size" {
  default     = 20
  description = "This is the volume size (GB) of the EBS volumes for the EKS worker nodes."
}

variable "worker_instance_type" {
  default     = "t3.xlarge"
  description = "This is the EC2 instance type for the EKS worker nodes."
}

variable "require_imdsv2" {
  default     = true
  description = "This is a bool whether to use AWS Instance Metadata Service Version 2 (IMDSv2)."
}

# Create AMI Mapping for Wavelength Zone (EKS 1.21)
variable "worker_image_id" {
  type = map(string)
  default = {
    "us-east-1" = "ami-0193ebf9573ebc9f7"
    "us-west-2" = "ami-0bb07d9c8d6ca41e8"
  }
  description = "This is the AMI for the EKS worker nodes with EKS version 1.21."
}

variable "worker_nodegroup_name" {
  default     = "Wavelength-Node-Group"
  description = "This is the name for the EKS worker nodes."

}

locals {
  ports_in = [
    443,
    80,
    22
  ]
  ports_out = [
    0
  ]
}
