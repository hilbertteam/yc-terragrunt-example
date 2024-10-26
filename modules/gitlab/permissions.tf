resource "gitlab_project_membership" "user-project-access" {
  project      = gitlab_project.repo.id
  user_id      = gitlab_user.user.id
  access_level = var.gitlab_user_project_access_level
}

resource "gitlab_project_membership" "owners" {
  for_each     = toset(var.project_owners)
  project      = gitlab_project.repo.id
  user_id      = data.gitlab_user.owners[each.key].id
  access_level = "owner"
}
