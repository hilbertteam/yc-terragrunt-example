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
  source = "../../../../modules/subnets"
}

inputs = {
  cloud_id    = "${local.env.yc_cloud_id}"
  folder_name = "${local.dir.dir_name}"

  folder_id = dependency.folder.outputs.folder_id
  
  vpc_id    = local.common.vpc_id
  subnets = [{
    name = format("subnet-public-%s", local.dir.dir_name)
    cidr = format("10.%s.0.0/16", local.envs.envs[local.dir.dir_name].subnet_octet)
    nat  = true
    zone = local.env.yc_zone_id
  }]
  gateway = true
}
