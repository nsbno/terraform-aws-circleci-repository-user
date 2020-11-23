variable "name_prefix" {
  description = "A prefix used for naming resources."
}

variable "allowed_s3_write_arns" {
  description = "A list of ARNs of S3 buckets that the user can write to."
  default     = []
  type        = list(string)
}

variable "allowed_s3_read_arns" {
  description = "A list of ARNs of S3 buckets that the user can read from."
  default     = []
  type        = list(string)
}

variable "allowed_ecr_arns" {
  description = "A list of ARNs of ECR repositories that the user can read from and write to."
  default     = []
  type        = list(string)
}

variable "ci_parameters_key" {
  description = "The ID or ARN of a KMS key or alias to use for encrypting the credentials when storing them in Parameter Store."
}

variable "tags" {
  description = "A map of tags (key-value pairs) passed to resources."
  type        = map(string)
  default     = {}
}
