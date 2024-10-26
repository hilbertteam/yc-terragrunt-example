locals {
  envs = {
    "dev" = {
      subnet_octet = "11",
      gitlab_project_force_recreate_salt = "0",
    },
    "stage" = {
      subnet_octet = "12",
      gitlab_project_force_recreate_salt = "0",
    },
    "prod" = {
      subnet_octet = "13",
      gitlab_project_force_recreate_salt = "0",
    },
  }
}
