resource "gitlab_project" "repo" {
  name = var.project_name
  import_url       = var.project_import_url
  namespace_id     = data.gitlab_group.group.id
  visibility_level = var.project_visibility_level

  lifecycle {
    replace_triggered_by = [null_resource.gitlab_project_force_recreate_salt]
  }
}

resource "null_resource" "gitlab_project_force_recreate_salt" {
  triggers = {
    salt = var.gitlab_project_force_recreate_salt
  }
}

