data "gitlab_user" "owners" {
  for_each = toset(var.project_owners)
  username = each.key
}

data "gitlab_group" "group" {
  full_path = var.group_full_path
}
