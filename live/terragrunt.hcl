locals {
  # backend
  s3_access_key = get_env("AWS_ACCESS_KEY_ID")
  s3_secret_key = get_env("AWS_SECRET_ACCESS_KEY")
  bucket_name = "<tf state s3 bucket name>"
  bucket_region = "ru-central1"
  dynamodb_endpoint = "<DynamoDB Document API endpoint>"
  dynamodb_table = "envs-tfstate-tf-lock"
}

generate "backend" {
  path      = "gen_backend.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
terraform {
  backend "s3" {
    endpoint = "https://storage.yandexcloud.net"
    bucket   = "${local.bucket_name}"
    region   = "${local.bucket_region}"
    key      = "envs/${path_relative_to_include()}/terraform.tfstate"
    access_key                  = "${local.s3_access_key}"
    secret_key                  = "${local.s3_secret_key}"

    skip_region_validation      = true
    skip_credentials_validation = true

    dynamodb_endpoint = "${local.dynamodb_endpoint}"
    dynamodb_table    = "${local.dynamodb_table}"
  }
}
EOF
}
