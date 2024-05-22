variable "name" {
  type        = string
  description = "Name of the backup policy"
}

variable "regions" {
  type        = list(string)
  default     = []
  description = "List of regions where resources to be backed up are located"
}

variable "vaults" {
  type = list(object({
    name               = string
    change_grace_days  = optional(number)
    min_retention_days = optional(number)
    max_retention_days = optional(number)
  }))

  default     = []
  description = "List of Backup Vaults to be created along with their lock configuration"
}

variable "plans" {
  type = list(object({
    name                    = string
    schedule                = string
    start_window_minutes    = optional(number, 60)
    complete_window_minutes = optional(number, 360)
    backup_tag_name         = optional(string, "BackupPolicy")
    backup_role_name        = optional(string, "lza-backup-service-linked-role")
    vault_name              = optional(string, "Default")

    copy_backups = optional(list(object({
      target_vault = string

      lifecycle = optional(object({
        cold_storage_after_days = optional(number)
        delete_after_days       = optional(number)
      }))
    })), [])

    lifecycle = optional(object({
      cold_storage_after_days = optional(number)
      delete_after_days       = optional(number)
    }))
  }))

  description = "List of plan definitions. Each definition defines a backup plan governing the frequency, destinations and retention settings."
}

variable "deployment_targets" {
  type        = list(string)
  default     = []
  description = "The accounts or organizational unit to attach the backup policy to."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Map of tags to apply to resources create by this module. These are also passed down to individual backups."
}
