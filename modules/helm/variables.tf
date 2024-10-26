variable "gitlab_fqdn" {
  type = string
  description = "fqdn of gitlab"
}

variable "runner_repo_token" {
  type = string
}

variable "agent_token" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "loadbalancer_ip" {
  type = string
  default = "value"
}

variable "ingress_host" {
  type = string
}
