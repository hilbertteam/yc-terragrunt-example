locals {
  env    = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  common = read_terragrunt_config(find_in_parent_folders("common.hcl")).locals
  dir    = read_terragrunt_config(find_in_parent_folders("dir.hcl")).locals
  users  = read_terragrunt_config(find_in_parent_folders("users.hcl")).locals

  subnet_name = format("subnet-public-%s", local.dir.dir_name)
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
    folder_id   = "fake_folder_id"
  }
}

dependency "subnet" {
  config_path = "../subnet"

  mock_outputs = {
    subnet_ids = {
      "${local.subnet_name}" = "fake_subnet_id"
    }
  }
}

terraform {
  source = "../../../../modules/kubernetes"
}

inputs = {
  folder_id    = dependency.folder.outputs.folder_id
  cluster_name = format("k8s-%s", local.dir.dir_name)
  network_id   = local.common.vpc_id
  master_locations = [for subnet_name, subnet_id in dependency.subnet.outputs.subnet_ids : 
    {
      zone      = local.env.yc_zone_id
      subnet_id = subnet_id
    }
  ]
  cluster_ipv4_range   = "172.17.0.0/20"
  service_ipv4_range   = "172.18.0.0/20"
  public_access        = false
  enable_cilium_policy = true
  node_groups = {
    "k8s-nodegroup" = {
      node_cores  = 2
      node_memory = 4
      disk_type   = "network-hdd"
      disk_size   = 32
    }
  }
}
