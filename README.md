[![New Relic Experimental header](https://github.com/newrelic/opensource-website/raw/master/src/images/categories/Experimental.png)](https://opensource.newrelic.com/oss-category/#new-relic-experimental)

# vz-newrelic-5g-edge [build badges go here when available]

>A Terraform module for deploying a multi-AZ EKS cluster leveraging Verizon’s 5G zones in AWS Wavelength. We are also experimenting with deploying both New Relic and Pixie using Terraform as part of this module.

## Installation

> [Include a step-by-step procedure on how to get your code installed. Be sure to include any third-party dependencies that need to be installed separately]

## Getting Started
>[Simple steps to start working with the software similar to a "Hello World"]

## Usage
>## New Relic / Pixie 5G Edge Module

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.40.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 3.40.0 |
| <a name="provider_helm"></a> [helm](#provider\_helm) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_eks_cluster"></a> [eks\_cluster](#module\_eks\_cluster) | terraform-aws-modules/eks/aws | n/a |

## Resources

| Name | Type |
|------|------|
| [aws_autoscaling_group.region_workers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_autoscaling_group.wavelength_workers](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_ec2_carrier_gateway.tf_carrier_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ec2_carrier_gateway) | resource |
| [aws_iam_instance_profile.worker_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.worker_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_internet_gateway.tf_internet_gw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_launch_template.region_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_launch_template.worker_launch_template](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_route.WLZ_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.region_route](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.WLZ_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.region_route_table](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.WLZ_route_associations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.region_route_associations](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group_rule.edge_newrelic_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_subnet.region_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.wavelength_subnets](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.tf_vpc](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [helm_release.newrelic](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [null_resource.apply_pixie](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.patch_coredns](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.patch_pixie](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [aws_eks_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster) | data source |
| [aws_eks_cluster_auth.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/eks_cluster_auth) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_availability_zones"></a> [availability\_zones](#input\_availability\_zones) | n/a | `map` | <pre>{<br>  "az1": {<br>    "availability_zone_id": "use1-az1",<br>    "cidr_block": "10.0.1.0/24"<br>  },<br>  "az2": {<br>    "availability_zone_id": "use1-az2",<br>    "cidr_block": "10.0.2.0/24"<br>  }<br>}</pre> | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `string` | `"wavelength"` | no |
| <a name="input_node_group_s3_bucket_url"></a> [node\_group\_s3\_bucket\_url](#input\_node\_group\_s3\_bucket\_url) | This is the S3 object URL of the EKS node group with auto-attached Carrier IPs. | `string` | `"https://wavelengthtutorials.s3.amazonaws.com/wlz-eks-node-group.yaml"` | no |
| <a name="input_nr_license_key"></a> [nr\_license\_key](#input\_nr\_license\_key) | New Relic License Key | `any` | n/a | yes |
| <a name="input_pixie_api_key"></a> [pixie\_api\_key](#input\_pixie\_api\_key) | Pixie API Key found in New Relic Guided Install | `any` | n/a | yes |
| <a name="input_pixie_deploy_key"></a> [pixie\_deploy\_key](#input\_pixie\_deploy\_key) | Pixie Deploy Key found in New Relic Guided Install | `any` | n/a | yes |
| <a name="input_profile"></a> [profile](#input\_profile) | AWS Credentials Profile to use | `string` | `"default"` | no |
| <a name="input_region"></a> [region](#input\_region) | This is the AWS region. | `string` | `"us-east-1"` | no |
| <a name="input_require_imdsv2"></a> [require\_imdsv2](#input\_require\_imdsv2) | This is a bool whether to use AWS Instance Metadata Service Version 2 (IMDSv2). | `bool` | `true` | no |
| <a name="input_wavelength_zones"></a> [wavelength\_zones](#input\_wavelength\_zones) | This is the Wavelength Zone deployment metadata for your VPC, including Availability Zone ID, CIDR range per WLZ, NodePort, and number of worker nodes. | `map` | <pre>{<br>  "bos": {<br>    "availability_zone": "us-east-1-wl1-bos-wlz-1",<br>    "availability_zone_id": "use1-wl1-bos-wlz1",<br>    "cidr_block": "10.0.11.0/24",<br>    "nodeport_offset": 30200,<br>    "worker_nodes": 1<br>  },<br>  "nyc": {<br>    "availability_zone": "us-east-1-wl1-nyc-wlz-1",<br>    "availability_zone_id": "use1-wl1-nyc-wlz1",<br>    "cidr_block": "10.0.10.0/24",<br>    "nodeport_offset": 30100,<br>    "worker_nodes": 1<br>  }<br>}</pre> | no |
| <a name="input_worker_image_id"></a> [worker\_image\_id](#input\_worker\_image\_id) | This is the AMI for the EKS worker nodes with EKS version 1.21. | `map(string)` | <pre>{<br>  "us-east-1": "ami-0193ebf9573ebc9f7",<br>  "us-west-2": "ami-0bb07d9c8d6ca41e8"<br>}</pre> | no |
| <a name="input_worker_instance_type"></a> [worker\_instance\_type](#input\_worker\_instance\_type) | This is the EC2 instance type for the EKS worker nodes. | `string` | `"t3.xlarge"` | no |
| <a name="input_worker_key_name"></a> [worker\_key\_name](#input\_worker\_key\_name) | This is your EC2 key name. | `string` | `"test_key"` | no |
| <a name="input_worker_nodegroup_name"></a> [worker\_nodegroup\_name](#input\_worker\_nodegroup\_name) | This is the name for the EKS worker nodes. | `string` | `"Wavelength-Node-Group"` | no |
| <a name="input_worker_volume_size"></a> [worker\_volume\_size](#input\_worker\_volume\_size) | This is the volume size (GB) of the EBS volumes for the EKS worker nodes. | `number` | `20` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->


## Building

>[**Optional** - Include this section if users will need to follow specific instructions to build the software from source. Be sure to include any third party build dependencies that need to be installed separately. Remove this section if it's not needed.]

## Testing

>[**Optional** - Include instructions on how to run tests if we include tests with the codebase. Remove this section if it's not needed.]

## Support

New Relic hosts and moderates an online forum where customers can interact with New Relic employees as well as other customers to get help and share best practices. Like all official New Relic open source projects, there's a related Community topic in the New Relic Explorers Hub. You can find this project's topic/threads here:

>Add the url for the support thread here

## Contributing
We encourage your contributions to improve [project name]! Keep in mind when you submit your pull request, you'll need to sign the CLA via the click-through using CLA-Assistant. You only have to sign the CLA one time per project.
If you have any questions, or to execute our corporate CLA, required if your contribution is on behalf of a company,  please drop us an email at opensource@newrelic.com.

**A note about vulnerabilities**

As noted in our [security policy](../../security/policy), New Relic is committed to the privacy and security of our customers and their data. We believe that providing coordinated disclosure by security researchers and engaging with the security community are important means to achieve our security goals.

If you believe you have found a security vulnerability in this project or any of New Relic's products or websites, we welcome and greatly appreciate you reporting it to New Relic through [HackerOne](https://hackerone.com/newrelic).

## License
[Project Name] is licensed under the [Apache 2.0](http://apache.org/licenses/LICENSE-2.0.txt) License.
>[If applicable: The [project name] also uses source code from third-party libraries. You can find full details on which libraries are used and the terms under which they are licensed in the third-party notices document.]
