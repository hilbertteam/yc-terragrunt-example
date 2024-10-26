output "user_password" {
  # value     = { for k, password in random_password.user-passwords : k => password.result }
  value     = random_password.user-password.result
  sensitive = true
}

output "project_runners_token" {
  # value     = { for k, repo in gitlab_project.repos : k => repo.runners_token }
  value     = gitlab_project.repo.runners_token
  sensitive = true
}

output "project_name" {
  # value     = { for k, repo in gitlab_project.repos : k => repo.name }
  value     = gitlab_project.repo.name
  sensitive = true
}

output "projects_id" {
  # value     = { for k, repo in gitlab_project.repos : k => repo.id }
  value     = gitlab_project.repo.id
  sensitive = true
}

output "agent_token" {
  # value     = { for k, agent in gitlab_cluster_agent_token.students_token : k => agent.token }
  value     = gitlab_cluster_agent_token.agent_token.token
  sensitive = true
}
