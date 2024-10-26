resource "gitlab_user" "user" {
  name             = var.user_name
  username         = var.user_name
  password         = random_password.user-password.result
  email            = format("%s@%s", var.user_name, var.user_email_domain)
  is_admin         = var.user_is_admin
  projects_limit   = var.user_projects_limit
  can_create_group = var.user_can_create_group
  is_external      = var.user_is_external
  reset_password   = var.user_reset_password
}

resource "random_password" "user-password" {
  length  = var.gitlab_user_password_length
  special = false
}
