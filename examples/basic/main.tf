module "basic" {
  source = "../.."

  name               = "general-backup"
  deployment_targets = ["ou-1tbg-wpzfzxb7"]

  plans = [{
    name                    = "daily"
    schedule                = "cron(0 3 ? * * *)"
    start_window_minutes    = "60"
    complete_window_minutes = "300"
    vault_name              = "Default"
    backup_tag_name         = "BackupPolicy"
    backup_role_name        = "lza-backup-service-linked-role"

    lifecycle = {
      delete_after_days = "7"
    }

    copy_backups = [{
      target_vault = "arn:aws:backup:eu-west-1:$account:backup-vault:FailoverVault"

      lifecycle = {
        cold_storage_after_days = "30"
        delete_after_days       = "365"
      }
    }]
    }, {
    name                    = "sunday-midnight"
    schedule                = "cron(0 5 ? * 1 *)"
    start_window_minutes    = "60"
    complete_window_minutes = "360"
    vault_name              = "Default"
    backup_tag_name         = "BackupPolicy"
    backup_role_name        = "lza-backup-service-linked-role"

    lifecycle = {
      cold_storage_after_days = "30"
      delete_after_days       = "365"
    }

    copy_backups = [{
      target_vault = "arn:aws:backup:eu-west-1:$account:backup-vault:FailoverVault"

      lifecycle = {
        cold_storage_after_days = "30"
        delete_after_days       = "365"
      }
    }]
  }]
}

#trivy:ignore:*
resource "aws_s3_bucket" "financial_audits" {
  bucket = "io-appvia-financial-audits"

  tags = {
    BackupPolicy = "sunday-midnight"
  }
}

#trivy:ignore:*
resource "aws_s3_bucket" "data_pending_processing" {
  bucket = "io-appvia-data-pending-processing"

  tags = {
    BackupPolicy = "daily"
  }
}
