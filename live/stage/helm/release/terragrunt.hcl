locals {
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
  dir    = read_terragrunt_config(find_in_parent_folders("dir.hcl")).locals
  envs   = read_terragrunt_config(find_in_parent_folders("envs.hcl")).locals

  subnet_name = format("subnet-public-%s", local.dir.dir_name)
}

include "root" {
  path = find_in_parent_folders()
}

include "helm" {
  path = find_in_parent_folders("helm.hcl")
}

dependency "gitlab" {
  config_path = "../../gitlab/repo"

  mock_outputs = {
    project_runners_token = "fake_project_runners_token"
    agent_token = "fake_agent_token"
  }
}

dependency "subnet" {
  config_path = "../../yandex/subnet"

  mock_outputs = {
    subnet_ids = {
      "${local.subnet_name}" = "fake_subnet_id"
    }
  }
}

terraform {
  source = "../../../../modules/helm"
}

inputs = {
  gitlab_fqdn = local.env.gitlab_fqdn
  runner_repo_token = dependency.gitlab.outputs.project_runners_token
  agent_token       = dependency.gitlab.outputs.agent_token
  subnet_id = dependency.subnet.outputs.subnet_ids[format("subnet-public-%s", local.dir.dir_name)]
  loadbalancer_ip = format("10.%s.0.200", local.envs.envs[local.dir.dir_name].subnet_octet)
  ingress_host = format("%s.%s", local.dir.dir_name, local.common.helm_ingress_domain)
  # student_name = local.dir.dir_name
}
