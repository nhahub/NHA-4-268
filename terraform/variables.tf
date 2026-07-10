variable "db_name" {
  default = "app_migration_db"
}

variable "db_username" {
  default = "am_user"
}

variable "discord_webhook_url" {
  type      = string
  sensitive = true
}