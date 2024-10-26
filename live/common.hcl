locals {
  # yandex
  vpc_id = "<common vpc id>"
  # gitlab
  gitlab_project_import_url = "<template git repo url>"
  gitlab_group_full_path = "<gitlab namespace to create repos from template>"
  # helm
  helm_ingress_domain = "<initial app ingress domain>"
}
