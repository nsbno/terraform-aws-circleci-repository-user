variable "name_prefix" {
  description = "A prefix used for naming resources."
}

variable "allowed_s3_arns" {
  default = ""
}

variable "allowed_s3_count" {
  default = 0
}

variable "allowed_ecr_count" {
  default = 0
}

variable "allowed_ecr_arns" {
  default = ""
}

variable "ci_parameters_key" {
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}