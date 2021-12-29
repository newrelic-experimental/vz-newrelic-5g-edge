[![New Relic Experimental header](https://github.com/newrelic/opensource-website/raw/master/src/images/categories/Experimental.png)](https://opensource.newrelic.com/oss-category/#new-relic-experimental)

# vz-newrelic-5g-edge

>A Terraform module for deploying a multi-AZ EKS cluster within Verizon’s 5G zones in AWS Wavelength. We are also experimenting with deploying both New Relic and Pixie using Terraform as part of this module.

## Installation

1. Clone the repository for the [vz-newrelic-5g-edge module](https://github.com/newrelic-experimental/vz-newrelic-5g-edge.git)

```
git clone https://github.com/newrelic-experimental/vz-newrelic-5g-edge
cd vz-newrelic-5g-edge/wavelength-cluster
```

2. Next, initialize Terraform within your working directory and create a preview of your deployment changes.

```
terraform init
terraform plan
```

3. Next, edit `terraform.tfvars.example` with any specific configuration details, such as your EKS cluster name, and specific Wavelength Zone(s) of interest.

```
mv terraform.tfvars.example terraform.tfvars
```

4. Apply the configuration by running `terraform apply.`


## Support

New Relic hosts and moderates an online forum where customers can interact with New Relic employees as well as other customers to get help and share best practices. Like all official New Relic open source projects, there's a related Community topic in the New Relic Explorers Hub. You can find this project's topic/threads here:

> Coming soon...

## Contributing
We encourage your contributions to improve `vz-newrelic-5g-edge`. Keep in mind when you submit your pull request, you'll need to sign the CLA via the click-through using CLA-Assistant. You only have to sign the CLA one time per project.
If you have any questions, or to execute our corporate CLA, required if your contribution is on behalf of a company,  please drop us an email at opensource@newrelic.com.

**A note about vulnerabilities**

As noted in our [security policy](../../security/policy), New Relic is committed to the privacy and security of our customers and their data. We believe that providing coordinated disclosure by security researchers and engaging with the security community are important means to achieve our security goals.

If you believe you have found a security vulnerability in this project or any of New Relic's products or websites, we welcome and greatly appreciate you reporting it to New Relic through [HackerOne](https://hackerone.com/newrelic).

## License
[Project Name] is licensed under the [Apache 2.0](http://apache.org/licenses/LICENSE-2.0.txt) License.
>[If applicable: The [project name] also uses source code from third-party libraries. You can find full details on which libraries are used and the terms under which they are licensed in the third-party notices document.]
