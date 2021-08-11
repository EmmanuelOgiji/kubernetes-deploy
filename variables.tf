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

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "List of cidr blocks for subnet creation. Used to give multiAZ resilience"
  default     = ["10.0.0.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "List of cidr blocks for subnet creation. Used to give multiAZ resilience"
  default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "standard_tags" {
  default = {
    "Owner" : "Emmanuel Pius-Ogiji",
    "Project" : "Kubernetes deployment"
  }
}