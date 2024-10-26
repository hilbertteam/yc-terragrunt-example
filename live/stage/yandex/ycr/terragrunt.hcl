locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
  dir = read_terragrunt_config(find_in_parent_folders("dir.hcl")).locals
  envs = read_terragrunt_config(find_in_parent_folders("envs.hcl")).locals
}

include "root" {
  path = find_in_parent_folders()
}

include "yandex" {
  path = find_in_parent_folders("yandex.hcl")
}

dependency "folder" {
  config_path = "../folder"

  mock_outputs = {
    folder_name = "fake_folder_name"
    folder_id = "fake_folder_id"
  }
}

terraform {
  source = "../../../../modules/ycr"
}

inputs = {
  name    = "user-registry"
  sa_name = format("ycr-pusher-%s", local.dir.dir_name)
  folder_id = dependency.folder.outputs.folder_id  
}
