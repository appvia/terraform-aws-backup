![Github Actions](../../actions/workflows/terraform.yml/badge.svg)

# Terraform <NAME>

## Description

Add a description of the module here

## Usage

Add example usage here

```hcl
module "example" {
  source  = "appvia/<NAME>/aws"
  version = "0.0.1"

  # insert variables here
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
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |

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
| <a name="input_organizational_unit"></a> [organizational\_unit](#input\_organizational\_unit) | The organizational unit to attach the backup policy to. | `string` | n/a | yes |
| <a name="input_plans"></a> [plans](#input\_plans) | List of plan definitions. Each definition defines a backup plan governing the frequency, destinations and retention settings. | <pre>list(object({<br>    name                    = string<br>    schedule                = string<br>    start_window_minutes    = optional(number, 60)<br>    complete_window_minutes = optional(number, 360)<br>    vault_name              = optional(string, "Default")<br>    backup_tag_name         = optional(string, "BackupPolicy")<br>    backup_role_name        = optional(string, "lza-backup-service-linked-role")<br><br>    copy_backups = optional(list(object({<br>      target_vault = string<br><br>      lifecycle = optional(object({<br>        cold_storage_after_days = optional(number)<br>        delete_after_days       = optional(number)<br>      }))<br>    })), [])<br><br>    lifecycle = optional(object({<br>      cold_storage_after_days = optional(number)<br>      delete_after_days       = optional(number)<br>    }))<br>  }))</pre> | `[]` | no |
| <a name="input_regions"></a> [regions](#input\_regions) | List of regions where resources to be backed up are located | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to apply to resources create by this module. These are also passed down to individual backups. | `map(string)` | `{}` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
