variable "vpc_id" {
  description = "(required) ID of the VPC to which the EKS cluster will be deployed"
  default     = ""
}

variable "subnet_ids" {
  description = "(required) IDs of the subnets to which the EKS worker nodes will be deployed"
  default     = []
}

variable "certificate_arn" {
  description = "(required) https://www.terraform.io/docs/providers/aws/r/lb_listener.html#certificate_arn"
  default     = ""
}

variable "env" {
  description = "(optional) Unique identifier used to name all resources"
  default     = "default"
}

variable "ssl_policy" {
  description = "(optional) https://docs.aws.amazon.com/elasticloadbalancing/latest/application/create-https-listener.html"
  default     = "ELBSecurityPolicy-TLS-1-2-2017-01"
}

variable "tags" {
  description = "(optional) Additional tags applied to all resources"
  default     = {}
}
