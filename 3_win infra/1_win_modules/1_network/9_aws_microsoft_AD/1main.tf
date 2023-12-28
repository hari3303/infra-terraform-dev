resource "aws_directory_service_directory" "awsMAD" {
  name     = "hbgseries.in"
  password = "hari@1995G"
  edition  = "Standard"
  type     = "MicrosoftAD"

  vpc_settings {
    vpc_id     = var.vpc_id
    subnet_ids = var.subnet_id
  }
}