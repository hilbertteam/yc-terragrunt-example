
###
# service accounts with role pusher
###

resource "yandex_iam_service_account" "ycr_pusher" {
  name        = var.sa_name
  description = "service account to push to YCR"
  folder_id = var.folder_id
}

resource "yandex_resourcemanager_folder_iam_member" "ycr_pusher_sa_role_image_pusher" {
  folder_id = var.folder_id
  role      = "container-registry.images.pusher"
  member    = "serviceAccount:${yandex_iam_service_account.ycr_pusher.id}"
}

resource "yandex_iam_service_account_key" "ycr_pusher_sa_auth_key" {
  service_account_id = yandex_iam_service_account.ycr_pusher.id
  description        = "${yandex_iam_service_account.ycr_pusher.name} YCR pusher key"
  key_algorithm      = "RSA_2048"
}

# ycr-pusher-sa-auth-key.json.tpl
data "template_file" "ycr_pusher_sa_auth_key" {
  template = file("${path.module}/templates/ycr-pusher-sa-auth-key.json.tpl")
  vars = {
    key_id             = yandex_iam_service_account_key.ycr_pusher_sa_auth_key.id
    service_account_id = yandex_iam_service_account_key.ycr_pusher_sa_auth_key.service_account_id
    created_at         = yandex_iam_service_account_key.ycr_pusher_sa_auth_key.created_at
    key_algorithm      = yandex_iam_service_account_key.ycr_pusher_sa_auth_key.key_algorithm
    public_key         = jsonencode(yandex_iam_service_account_key.ycr_pusher_sa_auth_key.public_key)
    private_key        = jsonencode(yandex_iam_service_account_key.ycr_pusher_sa_auth_key.private_key)
  }
}
