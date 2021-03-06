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

variable "cluster_name" {
  type        = string
  description = "Name of the EKS cluster"
  default     = "k8s-deploy"
}

variable "instance_types" {
  type        = list(string)
  description = "List of instance type to use in nodes"
  default     = ["t2.medium"]
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  description = "List of cidr blocks for subnet creation. Used to give multiAZ resilience"
  default     = ["10.0.0.0/24", "10.0.2.0/24"]
}

variable "public_subnet_cidr_blocks" {
  type        = list(string)
  description = "List of cidr blocks for subnet creation. Used to give multiAZ resilience"
  default     = ["10.0.6.0/24", "10.0.8.0/24"]
}

variable "standard_tags" {
  default = {
    "Owner" : "Emmanuel Pius-Ogiji",
    "Project" : "Kubernetes deployment"
  }
}