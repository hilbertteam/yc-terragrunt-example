###
# user
###
variable "user_name" {
  type        = string
  description = "gitlab user name"
}

variable "user_email_domain" {
  type        = string
  default     = "example.com"
  description = "gitlab user email domain"
}

variable "user_projects_limit" {
  type        = number
  default     = 1
  description = "gitlab user projects limit"
}

variable "user_is_admin" {
  type        = bool
  default     = false
  description = "gitlab user is admin"
}

variable "user_can_create_group" {
  type        = bool
  default     = false
  description = "gitlab user can create group"
}

variable "user_is_external" {
  type        = bool
  default     = false
  description = "gitlab user is external"
}

variable "user_reset_password" {
  type        = bool
  default     = false
  description = "gitlab reset user password"
}

variable "gitlab_user_password_length" {
  type        = number
  default     = 16
  description = "gitlab user password length"
}

variable "gitlab_user_project_access_level" {
  type        = string
  default     = "maintainer"
  description = "gitlab user project access level (owner|maintainer|developer|reporter)"
}

###
# group
###
variable "group_full_path" {
  type        = string
  description = "project existing group path"
}

###
# project
###
variable "project_name" {
  type        = string
  description = "gitlab project name"
}

variable "project_import_url" {
  type        = string
  description = "gitlab project import url"
}

variable "project_visibility_level" {
  type        = string
  default     = "private"
  description = "gitlab project visibility level"
}

variable "project_owners" {
  type        = list(string)
  default     = []
  description = "gitlab project owners (list of existing usernames)"
}

variable "gitlab_project_force_recreate_salt" {
  type        = string
  default     = "0"
  description = "Just change value to trigger project recreation. WARNING! All changes will be lost!"
}

###
# project variables
###
variable "project_variables" {
  type = map(object({
    value = string
    description = optional(string, null)
    environment_scope = optional(string, "*")
    masked = optional(bool, false)
    protected = optional(bool, false)
    raw = optional(bool, false)
    variable_type = optional(string, "env_var")
  }))
  default = {}
  # {
  #   VAR_NAME = {
  #     value = "var value"
  #     description = "var descr"
  #     environment_scope = "*"
  #     masked = false
  #     protected = false
  #     raw = false
  #     variable_type = "env_var"  # env_var or file
  #   }
  # }
  description = "Map of project variables"
}

###
# cluster agent
###
variable "cluster_agent_name" {
  type        = string
  default     = "gitlab-agent"
  description = "gitlab cluster agent name"
}

variable "cluster_agent_token_name" {
  type        = string
  default     = "gitlab-agent-token"
  description = "gitlab cluster agent token name"
}
