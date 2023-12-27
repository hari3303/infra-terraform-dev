variable "repository_names" {
  type    = list(string)
  default = ["repo1", "repo2", "repo3"]  # Add your repository names here
}

variable "image_expiration_days" {
  type    = number
  default = 30  # Number of days after which images will be deleted
}
variable "image_tag_mutability" {}