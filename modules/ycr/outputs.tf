output "user_registry_id" {
  value = yandex_container_registry.registry.id
}

output "ycr_pusher_sa_auth_key" {
  value = data.template_file.ycr_pusher_sa_auth_key
  sensitive = true
}

output "ycr_pusher_sa_auth_key_file_rendered" {
  value = data.template_file.ycr_pusher_sa_auth_key.rendered
  sensitive = true
}