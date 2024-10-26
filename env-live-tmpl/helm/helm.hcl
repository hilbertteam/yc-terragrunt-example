locals {
  env = read_terragrunt_config(find_in_parent_folders("env.hcl")).locals
  dir = read_terragrunt_config(find_in_parent_folders("dir.hcl")).locals
}

dependency "folder" {
  config_path = "${get_terragrunt_dir()}/../../yandex/folder"

  mock_outputs = {
    folder_name = "fake_folder_name"
    folder_id = "fake_folder_id"
  }
}

dependency "k8s_cluster" {
  config_path = "${get_terragrunt_dir()}/../../yandex/k8s-cluster"

  mock_outputs = {
    internal_v4_endpoint = "fake_internal_v4_endpoint"
    cluster_ca_certificate = "fake_cluster_ca_certificate"
  }
}

generate "provider" {
  path = "gen_providers.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "helm" {
  kubernetes {
    host                   = "${dependency.k8s_cluster.outputs.internal_v4_endpoint}"
    cluster_ca_certificate = base64decode("${base64encode(dependency.k8s_cluster.outputs.cluster_ca_certificate)}")
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      command     = "yc"
      args        = ["--folder-name", "${dependency.folder.outputs.folder_name}", "k8s", "create-token"]
    }
  }
}
EOF
}
