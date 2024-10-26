locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
}

generate "provider" {
  path = "gen_providers.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "yandex" {
  cloud_id  = "${local.env.yc_cloud_id}"
  zone      = "${local.env.yc_zone_id}"
  folder_id = "${local.env.yc_folder_id}"
}
EOF
}