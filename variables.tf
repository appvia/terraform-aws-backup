variable "name" {
  type        = string
  description = "Name of the backup policy"
}

variable "regions" {
  type        = list(string)
  default     = []
  description = "List of regions where resources to be backed up are located"
}

variable "plans" {
  type = list(object({
    name                    = string
    schedule                = string
    start_window_minutes    = optional(number, 60)
    complete_window_minutes = optional(number, 360)
    vault_name              = optional(string, "Default")
    backup_tag_name         = optional(string, "BackupPolicy")
    backup_role_name        = optional(string, "lza-backup-service-linked-role")

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

  default = []
}

variable "organizational_unit" {
  type        = string
  description = "The organizational unit to attach the backup policy to"
}

variable "tags" {
  type    = map(string)
  default = {}
}
