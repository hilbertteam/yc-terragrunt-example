variable "name" {
    type = string
    description = "YCR registry name"
}

variable "folder_id" {
    type = string
    default = null
    description = "folder id to create YCR in"
}

variable "sa_name" {
    type = string
    default = "ycr-pusher"
    description = "name of service account with role container-registry.images.pusher"
}
