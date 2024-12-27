<!-- markdownlint-disable -->
<a href="https://www.appvia.io/"><img src="https://github.com/appvia/terraform-aws-backup/blob/main/appvia_banner.jpg?raw=true" alt="Appvia Banner"/></a><br/><p align="right"> <a href="https://registry.terraform.io/modules/appvia/backup/aws/latest"><img src="https://img.shields.io/static/v1?label=APPVIA&message=Terraform%20Registry&color=191970&style=for-the-badge" alt="Terraform Registry"/></a></a> <a href="https://github.com/appvia/terraform-aws-backup/releases/latest"><img src="https://img.shields.io/github/release/appvia/terraform-aws-backup.svg?style=for-the-badge&color=006400" alt="Latest Release"/></a> <a href="https://appvia-community.slack.com/join/shared_invite/zt-1s7i7xy85-T155drryqU56emm09ojMVA#/shared-invite/email"><img src="https://img.shields.io/badge/Slack-Join%20Community-purple?style=for-the-badge&logo=slack" alt="Slack Community"/></a> <a href="https://github.com/appvia/terraform-aws-backup/graphs/contributors"><img src="https://img.shields.io/github/contributors/appvia/terraform-aws-backup.svg?style=for-the-badge&color=FF8C00" alt="Contributors"/></a>

<!-- markdownlint-restore -->
<!--
  ***** CAUTION: DO NOT EDIT ABOVE THIS LINE ******
-->

![Github Actions](https://github.com/appvia/terraform-aws-backup/actions/workflows/terraform.yml/badge.svg)

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
## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | >= 5 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_name"></a> [name](#input\_name) | Name of the backup policy | `string` | n/a | yes |
| <a name="input_plans"></a> [plans](#input\_plans) | List of plan definitions. Each definition defines a backup plan governing the frequency, destinations and retention settings. | <pre>list(object({<br/>    name                    = string<br/>    schedule                = string<br/>    start_window_minutes    = optional(number, 60)<br/>    complete_window_minutes = optional(number, 360)<br/>    backup_tag_name         = optional(string, "BackupPolicy")<br/>    backup_role_name        = optional(string, "lza-backup-service-linked-role")<br/>    vault_name              = optional(string, "Default")<br/><br/>    copy_backups = optional(list(object({<br/>      target_vault = string<br/><br/>      lifecycle = optional(object({<br/>        cold_storage_after_days = optional(number)<br/>        delete_after_days       = optional(number)<br/>      }))<br/>    })), [])<br/><br/>    lifecycle = optional(object({<br/>      cold_storage_after_days = optional(number)<br/>      delete_after_days       = optional(number)<br/>    }))<br/>  }))</pre> | n/a | yes |
| <a name="input_deployment_targets"></a> [deployment\_targets](#input\_deployment\_targets) | The accounts or organizational unit to attach the backup policy to. | `list(string)` | `[]` | no |
| <a name="input_regions"></a> [regions](#input\_regions) | List of regions where resources to be backed up are located | `list(string)` | `[]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to apply to resources create by this module. These are also passed down to individual backups. | `map(string)` | `{}` | no |
| <a name="input_vaults"></a> [vaults](#input\_vaults) | List of Backup Vaults to be created along with their lock configuration | <pre>list(object({<br/>    name               = string<br/>    change_grace_days  = optional(number)<br/>    min_retention_days = optional(number)<br/>    max_retention_days = optional(number)<br/>  }))</pre> | `[]` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
