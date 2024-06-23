locals {
  # CloudFormation templates directory
  cf_dir = format("%s/cloud_formation", path.module)

  # CloudFormation templates
  cf_role_tpl  = file(format("%s/role.yaml", local.cf_dir))
  cf_vault_tpl = file(format("%s/vault.yaml", local.cf_dir))

  # List of regions to apply backups
  backup_regions = coalescelist(var.regions, [
    data.aws_region.current.name,
  ])
}

locals {
  vaults_per_region = merge([
    for v in var.vaults : {
      for r in local.backup_regions :
      lower("${r}-${v.name}") => {
        vault  = v
        region = r
      }
    }
  ]...)

  all_role_names = toset([
    for p in var.plans : p.backup_role_name
    if p.backup_role_name != "lza-backup-service-linked-role"
  ])
}

locals {
  backup_plans = {
    for p in var.plans :
    p.name => {
      regions = {
        "@@assign" = local.backup_regions
      }

      rules = {
        (p.name) = {
          target_backup_vault_name = {
            "@@assign" = p.vault_name
          }

          schedule_expression = {
            "@@assign" = p.schedule
          }

          start_backup_window_minutes = {
            "@@assign" = tostring(p.start_window_minutes)
          }

          complete_backup_window_minutes = {
            "@@assign" = tostring(p.complete_window_minutes)
          }

          copy_actions = {
            for b in p.copy_backups :
            (b.target_vault) => {
              target_backup_vault_arn = {
                "@@assign" = b.target_vault
              }

              lifecycle = merge(
                {},
                try(b.lifecycle.cold_storage_after_days, null) == null ? {} : {
                  move_to_cold_storage_after_days = {
                    "@@assign" : tostring(b.lifecycle.cold_storage_after_days)
                  }
                },
                try(b.lifecycle.delete_after_days, null) == null ? {} : {
                  delete_after_days = {
                    "@@assign" : tostring(b.lifecycle.delete_after_days)
                  }
                },
              )
            }
          }

          lifecycle = merge(
            {},
            try(p.lifecycle.cold_storage_after_days, null) == null ? {} : {
              move_to_cold_storage_after_days = {
                "@@assign" : tostring(p.lifecycle.cold_storage_after_days)
              }
            },
            try(p.lifecycle.delete_after_days, null) == null ? {} : {
              delete_after_days = {
                "@@assign" : tostring(p.lifecycle.delete_after_days)
              }
            },
          )
        }
      }

      selections = {
        tags = {
          backup-policy = {
            iam_role_arn = {
              "@@assign" = "arn:aws:iam::$account:role/${p.backup_role_name}"
            }

            tag_key = {
              "@@assign" = p.backup_tag_name
            }

            tag_value = {
              "@@assign" = [
                p.name,
              ]
            }
          }
        }
      }

      backup_plan_tags = {
        for k, v in var.tags :
        k => {
          tag_key = {
            "@@assign" = k
          }

          tag_value = {
            "@@assign" = v
          }
        }
      }
    }
  }
}
