resource "gitlab_cluster_agent" "agent" {
  project = gitlab_project.repo.id
  name    = var.cluster_agent_name
}

resource "gitlab_cluster_agent_token" "agent_token" {
  name     = var.cluster_agent_token_name
  agent_id = gitlab_cluster_agent.agent.agent_id
  project  = gitlab_project.repo.id
}
