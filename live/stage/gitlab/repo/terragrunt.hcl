locals {
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
  dir = read_terragrunt_config(find_in_parent_folders("dir.hcl")).locals
  envs = read_terragrunt_config(find_in_parent_folders("envs.hcl")).locals
}

include "root" {
  path = find_in_parent_folders()
}

include "gitlab" {
  path = find_in_parent_folders("gitlab.hcl")
}

terraform {
  source = "../../../../modules/gitlab"
}

dependency "ycr" {
  config_path = "../../yandex/ycr"

  mock_outputs = {
    user_registry_id = "fake_user_registry_id"
    ycr_pusher_sa_auth_key_file_rendered = "fake_ycr_pusher_sa_auth_key_file_rendered"
  }
}

inputs = {
  user_name = local.dir.dir_name
  group_full_path = local.common.gitlab_group_full_path
  project_name = local.dir.dir_name
  project_import_url = local.common.gitlab_project_import_url
  gitlab_project_force_recreate_salt = "${local.envs.envs[local.dir.dir_name].gitlab_project_force_recreate_salt}"
  project_owners = [
    # "vsyscoder",
    # "kazhem"
  ]
  project_variables = {
    CI_REGISTRY = {
      value = format("cr.yandex/%s", dependency.ycr.outputs.user_registry_id)
      masked = false
      protected = false
      raw = true
    }
    CI_REGISTRY_KEY = {
      value = dependency.ycr.outputs.ycr_pusher_sa_auth_key_file_rendered
      masked = false
      protected = false
      raw = true
    }

    DOMAIN_NAME = {
      value = local.common.helm_ingress_domain
      masked = false
      protected = false
      raw = true
    }
  }
}
