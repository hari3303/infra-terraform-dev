variable "hz_name" {}
variable "vpc_id" {}
variable "route53_records" {
  description = "List of objects representing route53 records"
  type        = list(object({
    route53_name = string
    ip           = string
  }))
  default     = []
}
