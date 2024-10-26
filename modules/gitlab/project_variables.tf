resource "gitlab_project_variable" "variable" {
  for_each          = var.project_variables

  project           = gitlab_project.repo.id
  key               = each.key
  value             = each.value.value

  description       = each.value.description
  environment_scope = each.value.environment_scope
  masked            = each.value.masked
  protected         = each.value.protected
  raw               = each.value.raw
  variable_type     = each.value.variable_type
}