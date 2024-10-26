locals {
  # gitlab
  gitlab_fqdn = "<GitLab fqdn>"
  gitlab_api_url = "https://${local.gitlab_fqdn}/api/v4/"
  gitlab_api_token = get_env("TF_VAR_gitlab_token")
  # yandex cloud
  yc_cloud_id = "<cloud id>"
  yc_zone_id = "ru-central1-d"
  yc_folder_id = "<folder id>"
}
