resource "yandex_container_registry" "registry" {
  name      = var.name
  folder_id = var.folder_id
}
