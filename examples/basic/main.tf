module "basic" {
  source  = "appvia/backup/aws"
  version = "1.0.0"

  name = "general-backup"

  plans = [{
    name                    = "weekly"
    schedule                = ""
    start_window_minutes    = "60"
    complete_window_minutes = "360"
    vault_name              = "Default"
    backup_tag_name         = "BackupPolicy"
    backup_role_name        = "lza-backup-service-linked-role"

    lifecycle = optional(object({
      cold_storage_after_days = "30"
      delete_after_days       = "365"
    }))

    copy_backups = [{
      target_vault = "arn:aws:backup:eu-west-1:$account:backup-vault:FailoverVault"

      lifecycle = {
        cold_storage_after_days = "30"
        delete_after_days       = "365"
      }
    }]
  }]
}
