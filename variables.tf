variable "name_prefix" {
  description = "A prefix used for naming resources."
  type        = string
}

variable "user_path" {
  description = "The path of the user in the IAM service"
  type        = string
  default     = "/machine-user/"
}

variable "artifact_bucket_arn" {
  description = "The name of the bucket where deployment artifacts are uploaded"
  type        = string
}

variable "documentation_portal_bucket_arn" {
  description = "The name of the bucket where api portal documentation is uploaded"
  type        = string
  default     = "arn:aws:s3:::727646359971-api-portal-artifacts"
}
