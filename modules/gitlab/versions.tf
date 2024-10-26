terraform {
  required_providers {
    gitlab = {
      source  = "gitlabhq/gitlab"
      version = ">=16.11.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.6.1"
    }
  }
}
