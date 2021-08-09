variable "region" {
  type        = string
  description = "The region for deployment"
  default     = "eu-west-1"
}

variable "access_key" {
  type        = string
  description = "The AWS access key to access the AWS account"
  default     = ""
}

variable "secret_key" {
  type        = string
  description = "The AWS secret key to access the AWS account"
  default     = ""
}

variable "standard_tags" {
  default = {
    "Owner" : "Emmanuel Pius-Ogiji",
    "Project" : "Kubernetes deployment"
  }
}