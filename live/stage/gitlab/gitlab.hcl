locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
}

generate "provider" {
  path = "gen_providers.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "gitlab" {
  base_url = "${local.env.gitlab_api_url}"
  token    = "${local.env.gitlab_api_token}"
}
EOF
}