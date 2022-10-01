# Prevent Service Interrupts with Security Groups

Prevent service interruptions by carefully declaring Security Group (SG) rule resource arguments.

## Key Concepts

#### One Resource to Many Rules

A single `aws_security_group_rule` may result in the EC2 API creating one or many security group rules> This occurs when multiple sources/destinations are provided or if a single source/destination has many list elements.

Please see [Resource: aws_security_group_rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) for more information.

#### Destroy Before Create (DBC) Lifecycle

> By default, when Terraform must change a resource argument that cannot be updated in-place due to remote API limitations, Terraform will instead destroy the existing object and then create a new replacement object with the new configured arguments.

#### Create Before Destroy (CBD) Lifecycle

> This is an opt-in behavior because many remote object types have unique name requirements or other constraints that must be accommodated for both a new and an old object to exist concurrently.

Please see [The `lifecycle` Meta-Argument](https://www.terraform.io/language/meta-arguments/lifecycle#create_before_destroy) for more information.

## Types of Interruptions

1. A SG rule update using DBC lifecycle management will result in the service being inaccessible during the period after the rule is deleted and before the rule is recreated.

2. A SG rule ID change will result in any `source_security_group_id` reference becoming [stale](https://docs.aws.amazon.com/AWSEC2/latest/APIReference/API_DescribeStaleSecurityGroups.html). The service will be restored when the `source_security_group_id` is updated with the new value.

## Considerations

1. By default, this module uses DBC for rules. Rule arguments are used to dynamically generate a unique key to be used in the modules `for_each` loop. Therefore, a new rule will be created any time the rule arguments change. The service will be inaccessible until the new rule is finished creating. Avoid needless replacements by reviewing consideration 3.

2. Declare the `key` argument for rules to use CBD lifecycle management. Avoid Terraform errors by reviewing consideration 3.

3. Avoid rules with multiple source/destination types or source/destination lists with more than one element. When a SG rule resource is managing multiple rules; a single source/destination change will result in all of the rules being replaced. With DBC, rules will needlessly be replaced. With CBD, the AWS API will return a duplicate rule error.

4. Avoid computed rules by passing known values. Unknown values must be computed using `count` which may cause undesirable rule churn when updates occur i.e. rule(s) will needlessly be replaced. Similar to consideration 3, computed rules must use DBC otherwise AWS API duplication errors will occur during rule churn. If you must use unknown values then please review the consideration 5.

5. Use the `name_prefix` argument when the SG ID does not need to be preserved (e.g. when used by resources that support multiple SG attachments like EC2 network interfaces). This module implements CBD for SGs declared with `name_prefix` and DBC with `name`. A future release may implement a `preserve_security_group_id = false` variable that when enabled will force the security group to recreate by interpolating a random ID into the `name_prefix` each run resulting in SG replacement every run.

6. Declare additional modules [only with rules](https://github.com/aidanmelen/terraform-aws-security-group-v2/tree/main/examples/rules_only) if you must preserve the SG ID (e.g. the SG is used by a load balancer or by an EKS cluster, etc) and are managing rule lifecycle's with DBC declare.

## Usage

To run this example you need to execute:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Simulate rule updates by commenting out the IPV4 rules and uncommenting the IPV6 rules and re-apply.

Note that this example may create resources which cost money. Run `terraform destroy` when you don't need these resources.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Examples

```hcl
################################################################################
# Consideration 1
################################################################################

module "consideration_1" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 1.4.0"

  name        = join("-", [local.name, 1])
  vpc_id      = data.aws_vpc.default.id
  description = "Rules with dynamic keys will use DBC lifecycle management"

  ingress = [
    # destroy the ipv4 rule after the ipv6 rule is applied
    {
      rule        = "https-443-tcp"
      cidr_blocks = [data.aws_vpc.default.cidr_block]
    },
    # {
    #   rule             = "https-443-tcp"
    #   ipv6_cidr_blocks = [data.aws_vpc.default.ipv6_cidr_block]
    # }
  ]
}

################################################################################
# Consideration 2
################################################################################

module "consideration_2" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 1.4.0"

  name        = join("-", [local.name, 2])
  vpc_id      = data.aws_vpc.default.id
  description = "Rules with user managed keys will use CBD lifecycle management"

  ingress = [
    {
      #   key         = "my-key"
      rule        = "https-443-tcp"
      cidr_blocks = [data.aws_vpc.default.cidr_block, "10.0.0.0/24"]
      # ipv6_cidr_blocks = [data.aws_vpc.default.ipv6_cidr_block]
    }
  ]

  matrix_ingress = {
    rules = [
      {
        # key  = "my-key"
        rule = "http-80-tcp"
      }
    ]
    cidr_blocks = [data.aws_vpc.default.cidr_block, "10.0.0.0/24"]
    # ipv6_cidr_blocks = [data.aws_vpc.default.ipv6_cidr_block]
  }
}

################################################################################
# Consideration 3
################################################################################

module "consideration_3" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 1.4.0"

  name        = join("-", [local.name, 3])
  vpc_id      = data.aws_vpc.default.id
  description = "Avoid rules with multiple sources/destinations"

  ingress = [
    # removing/updating IPV4 rule will not effect the IPV6 rule and vica versa
    {
      rule        = "https-443-tcp"
      cidr_blocks = [data.aws_vpc.default.cidr_block]
    },
    # removing/updating IPV6 rule will not cause AWS API duplication errors
    {
      key              = "my-rule"
      rule             = "https-443-tcp"
      ipv6_cidr_blocks = [data.aws_vpc.default.ipv6_cidr_block]
    }
  ]

  # matrix rules will create a rule for each source/destination
  matrix_ingress = {
    rules = [
      {
        key  = "my-key"
        rule = "http-80-tcp"
      }
    ]
    cidr_blocks      = [data.aws_vpc.default.cidr_block]
    ipv6_cidr_blocks = [data.aws_vpc.default.ipv6_cidr_block]
  }
}

################################################################################
# Consideration 4
################################################################################

module "consideration_4" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 1.4.0"

  name_prefix = join("-", [local.name, 4])
  vpc_id      = data.aws_vpc.default.id
  description = "Avoid computed rules by passing known values. Unknown values must be computed using count which may cause undesirable rule churn when updates occur"

  computed_ingress = [
    # commenting out the first rule will cause churn and
    # result in a service interrupt for the rule using the prefix_list_ids
    {
      rule                     = "https-443-tcp"
      source_security_group_id = aws_security_group.other.id
    },
    # commenting out the second rule will not cause churn
    {
      rule            = "https-443-tcp"
      prefix_list_ids = [aws_ec2_managed_prefix_list.other.id]
    }
  ]
}

################################################################################
# Consideration 5
################################################################################

module "consideration_5" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 1.4.0"

  name_prefix = join("-", [local.name, 5, "blue"])
  # Force a SG level CBD with a name change
  # name_prefix = join("-", [local.name, 5, "green"])
  vpc_id      = data.aws_vpc.default.id
  description = "Use the name_prefix argument when the SG ID does not need to be preserved"

  ingress = [
    {
      rule        = "https-443-tcp"
      cidr_blocks = [data.aws_vpc.default.cidr_block]
      # ipv6_cidr_blocks = [data.aws_vpc.default.ipv6_cidr_block]
    }
  ]
}

# the ENI will updated with the new SG ID before the old SG is destroyed
# thus preventing a service interruption
resource "aws_network_interface" "consideration_5" {
  subnet_id       = data.aws_subnet.default.id
  private_ips     = [cidrhost(data.aws_subnet.default.cidr_block, 10)]
  security_groups = [module.consideration_5.security_group.id]

  tags = {
    Name = join("-", [local.name, 5])
  }
}

################################################################################
# Consideration 6
################################################################################

module "consideration_6" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 1.4.0"

  name        = join("-", [local.name, 6])
  vpc_id      = data.aws_vpc.default.id
  description = "The SG ID must be preserved because it is used by a load balancer"

  computed_ingress = [
    {
      rule                     = "https-443-tcp"
      source_security_group_id = aws_security_group.other.id
      # uncommenting will result in a service interruption for source_security_group_id
      # and we cannot use CBD because it is not support with computed rules.
      # prefix_list_ids        = [aws_ec2_managed_prefix_list.other.id]
    }
  ]
}

# this module rule will have no effect on the source_security_group_id
# module "consideration_6_rules_only" {
#   source  = "aidanmelen/security-group-v2/aws"
  version = ">= 1.4.0"

#   create_security_group = false
#   security_group_id     = module.consideration_6.security_group.id
#   description           = "This additional rule will preserve the SG ID and will not effect the pre-existing rules."

#   computed_ingress = [
#     {
#       rule            = "https-443-tcp"
#       prefix_list_ids = [aws_ec2_managed_prefix_list.other.id]
#     }
#   ]
# }

resource "aws_lb" "consideration_6" {
  name                       = join("-", [substr(local.name, 0, 30), 6])
  drop_invalid_header_fields = true
  internal                   = true
  load_balancer_type         = "application"
  security_groups            = [module.consideration_6.security_group.id]
  subnets                    = data.aws_subnets.default.ids

  tags = {
    Name = join("-", [local.name, 6])
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 0.13.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 3.29 |
## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_consideration_1"></a> [consideration\_1](#module\_consideration\_1) | ../../ | n/a |
| <a name="module_consideration_2"></a> [consideration\_2](#module\_consideration\_2) | ../../ | n/a |
| <a name="module_consideration_3"></a> [consideration\_3](#module\_consideration\_3) | ../../ | n/a |
| <a name="module_consideration_4"></a> [consideration\_4](#module\_consideration\_4) | ../../ | n/a |
| <a name="module_consideration_5"></a> [consideration\_5](#module\_consideration\_5) | ../../ | n/a |
| <a name="module_consideration_6"></a> [consideration\_6](#module\_consideration\_6) | ../../ | n/a |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS Region. | `string` | `"us-west-2"` | no |
## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
