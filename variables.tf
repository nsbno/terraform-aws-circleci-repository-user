variable "name_prefix" {
  description = "A prefix used for naming resources."
}

variable "allowed_s3_arns" {
  default = []
  type    = list(string)
}

variable "allowed_s3_count" {
  default = 0
}

variable "allowed_ecr_count" {
  default = 0
}

variable "allowed_ecr_arns" {
  default = []
  type    = list(string)
}

variable "ci_parameters_key" {
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}

variable "permissions_boundary" {
  description = "The ARN of a permissions boundary for any IAM resources created to include"
  type        = string
  default     = ""
}