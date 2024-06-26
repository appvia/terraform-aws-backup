![Github Actions](../../actions/workflows/terraform.yml/badge.svg)

# Terraform AWS Organizations Backup

## Description

This module creates an AWS Organization Backup Policy consisting of one or more backup plans to be deployed to
accounts within the specified Organizational Unit.

## Usage

The following example creates a generalised backup policy targeting all compatible AWS Backup resources. Resources are matched
if they have a tag with the key `BackupPolicy` and a value matching the plan name - in this case `daily`. This policy is
applied to all accounts within the specified organizational unit and is run on a daily schedule starting at 3am.

```hcl
module "basic" {
  source  = "appvia/backup/aws"
  version = "1.0.0"

  name                = "general-backup"
  organizational_unit = "ou-1tbg-wpzfzxb7"

  plans = [{
    name                    = "daily"
    schedule                = "cron(0 3 ? * * *)"
    start_window_minutes    = "60"
    complete_window_minutes = "300"
  }]
}

resource "aws_s3_bucket" "data_pending_processing" {
  bucket = "io-appvia-data-pending-processing"

  tags = {
    BackupPolicy = "daily"
  }
}
```

## Update Documentation

The `terraform-docs` utility is used to generate this README. Follow the below steps to update:

1. Make changes to the `.terraform-docs.yml` file
2. Fetch the `terraform-docs` binary (https://terraform-docs.io/user-guide/installation/)
3. Run `terraform-docs markdown table --output-file ${PWD}/README.md --output-mode inject .`

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.7 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_cloudformation_stack_set.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set) | resource |
| [aws_cloudformation_stack_set.vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set) | resource |
| [aws_cloudformation_stack_set_instance.role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set_instance) | resource |
| [aws_cloudformation_stack_set_instance.vault](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudformation_stack_set_instance) | resource |
| [aws_organizations_policy.backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy) | resource |
| [aws_organizations_policy_attachment.backup](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/organizations_policy_attachment) | resource |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name of the backup policy | `string` | n/a | yes |
| <a name="input_plans"></a> [plans](#input\_plans) | List of plan definitions. Each definition defines a backup plan governing the frequency, destinations and retention settings. | <pre>list(object({<br>    name                    = string<br>    schedule                = string<br>    start_window_minutes    = optional(number, 60)<br>    complete_window_minutes = optional(number, 360)<br>    backup_tag_name         = optional(string, "BackupPolicy")<br>    backup_role_name        = optional(string, "lza-backup-service-linked-role")<br>    vault_name              = optional(string, "Default")<br><br>    copy_backups = optional(list(object({<br>      target_vault = string<br><br>      lifecycle = optional(object({<br>        cold_storage_after_days = optional(number)<br>        delete_after_days       = optional(number)<br>      }))<br>    })), [])<br><br>    lifecycle = optional(object({<br>      cold_storage_after_days = optional(number)<br>      delete_after_days       = optional(number)<br>    }))<br>  }))</pre> | n/a | yes |
| <a name="input_deployment_targets"></a> [deployment\_targets](#input\_deployment\_targets) | The accounts or organizational unit to attach the backup policy to. | `list(string)` | `[]` | no |
| <a name="input_regions"></a> [regions](#input\_regions) | List of regions where resources to be backed up are located | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to apply to resources create by this module. These are also passed down to individual backups. | `map(string)` | `{}` | no |
| <a name="input_vaults"></a> [vaults](#input\_vaults) | List of Backup Vaults to be created along with their lock configuration | <pre>list(object({<br>    name               = string<br>    change_grace_days  = optional(number)<br>    min_retention_days = optional(number)<br>    max_retention_days = optional(number)<br>  }))</pre> | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
