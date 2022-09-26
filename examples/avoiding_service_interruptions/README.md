# Avoiding Service Interrupts with Security Groups/Rules

Depending how a Security Group and Rule lifecycle's are managed by Terraform and what AWS resources are depending on them will determine how to best avoid a service interruption when updates occur.

## Key Concepts

#### Destroy Before Create (DBC) Lifecycle

> By default, when Terraform must change a resource argument that cannot be updated in-place due to remote API limitations, Terraform will instead destroy the existing object and then create a new replacement object with the new configured arguments.

Please see [The `lifecycle` Meta-Argument](https://www.terraform.io/language/meta-arguments/lifecycle#create_before_destroy) for more information.

#### Create Before Destroy (CBD) Lifecycle

> This is an opt-in behavior because many remote object types have unique name requirements or other constraints that must be accommodated for both a new and an old object to exist concurrently.

Please see [The `lifecycle` Meta-Argument](https://www.terraform.io/language/meta-arguments/lifecycle#create_before_destroy) for more information.

## Types of Interruptions

1. When a security group rule is updated using DBC lifecycle management; the service will be inaccessible during the period after the rule is deleted and before the rule is recreated.

2. A SG replacement will cause an interruption if depended on by another SG via the `source_security_group_id` argument and that SG is managed in another Terraform run or outside of Terraform all together. The service would be restored when the `source_security_group_id` is updated with the new value.

## Considerations

1. Declare the `key` argument for rules to use CBD.

2. By default, this module will dynamically generate a key from the rule arguments to be used in the `for_each` loop. Therefore, updating the rule will cause the old rule to be destroyed and another rule to be created with the new key, concurrently. These actions are performed automatically; however, in order to guarantee CRB with dynamic keys, it is best to add the new rule in one terraform run and remove the old rule in a second run.

3. Avoid computed rules by passing known values. Unknown values must be computed using `count` which may cause undesirable rule churn when updates occur i.e. rule(s) will needlessly get destroyed then immediately recreated again. Rule churn must use DBC otherwise duplication error occur. On the other hand, this module implements all other rules using `for_each` loop with map keys which do not suffer from churn and are implemented with CDB. If you must use unknown values then please review the consideration 5.

4. Create SG rules with a single subject. When a `aws_security_group_rule` resource is declared with multiple subjects (e.g. `cidr_blocks`, `ipv6_cidr_blocks`, `prefix_list_ids`, `source_security_group_id`, and/or `self`), updating a single subject will result in all of the rules being replaced since they are all managed by the same Terraform resource.

5. Use the `name_prefix` argument when the SG ID does not need to be preserved (e.g. when used by resources that support multiple SG attachments like EC2 network interfaces). This module implements CBD for SGs declared with `name_prefix` and DBC with `name`. Force the SG replacement using the [-replace option](https://www.terraform.io/cli/commands/plan#replace-address) or simply change the `name_prefix`.

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
module "consideration_1" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 1.4.0"

  name        = join("-", [local.name, 1])
  vpc_id      = data.aws_vpc.default.id
  description = "Declare the key argument for rules to use CBD."

  ingress = [
    {
      key         = "my-key"
      rule        = "https-443-tcp"
      cidr_blocks = [data.aws_vpc.default.cidr_block]
      # ipv6_cidr_blocks = [data.aws_vpc.default.ipv6_cidr_block]
    }
  ]

  matrix_ingress = {
    rules = [
      {
        key  = "my-key"
        rule = "http-80-tcp"
      }
    ]
    cidr_blocks = [data.aws_vpc.default.cidr_block]
    # ipv6_cidr_blocks = [data.aws_vpc.default.ipv6_cidr_block]
  }
}

module "consideration_2" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 1.4.0"

  name        = join("-", [local.name, 2])
  vpc_id      = data.aws_vpc.default.id
  description = "In order to guarantee CRB with dynamic keys, it is best to add the new rule in one terraform run and remove the old rule in a second run."

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

module "consideration_3" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 1.4.0"

  name_prefix = join("-", [local.name, 3])
  vpc_id      = data.aws_vpc.default.id
  description = "Avoid computed rules by passing known values. Unknown values must be computed using count which may cause undesirable rule churn when updates occur."

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


module "consideration_4" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 1.4.0"

  name   = join("-", [local.name, 4])
  vpc_id = data.aws_vpc.default.id

  ingress = [
    # removing/updating IPV4 rule will not effect the IPV6 rule
    {
      rule        = "https-443-tcp"
      cidr_blocks = [data.aws_vpc.default.cidr_block]
    },
    {
      rule             = "https-443-tcp"
      ipv6_cidr_blocks = [data.aws_vpc.default.ipv6_cidr_block]
    }
  ]
}

module "consideration_5" {
  source  = "aidanmelen/security-group-v2/aws"
  version = ">= 1.4.0"

  name_prefix = join("-", [local.name, 5, "blue"])
  # Force a SG level CBD with a name change
  # name_prefix = join("-", [local.name, 5, "green"])
  vpc_id      = data.aws_vpc.default.id
  description = "Use the name_prefix argument when the SG ID does not need to be preserved."

  computed_ingress = [
    {
      rule                     = "https-443-tcp"
      source_security_group_id = aws_security_group.other.id
      # prefix_list_ids        = [aws_ec2_managed_prefix_list.other.id]
    }
  ]
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
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_aws_region"></a> [aws\_region](#input\_aws\_region) | The AWS Region. | `string` | `"us-west-2"` | no |
## Outputs

No outputs.
<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
