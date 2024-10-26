locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  dir = read_terragrunt_config(find_in_parent_folders("dir.hcl")).locals
  users = read_terragrunt_config(find_in_parent_folders("users.hcl")).locals
}

include "root" {
  path = find_in_parent_folders()
}

include "yandex" {
  path = find_in_parent_folders("yandex.hcl")
}

terraform {
  source = "../../../../modules/folder"
}

inputs = {
  cloud_id    = "${local.env.yc_cloud_id}"
  folder_name = "${local.dir.dir_name}"
}

# generate "user-folders" {
#   path = "gen_folders.tf"
#   if_exists = "overwrite_terragrunt"
#   contents = templatefile("folders.tmpl", {
#     cloud_id     = local.env.yc_cloud_id
#     users = local.users.users
#   })
# }