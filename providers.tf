provider "aws" {
  region     = local.aws_credentials.main_credentials.region
  access_key = local.aws_credentials.main_credentials.access_key
  secret_key = local.aws_credentials.main_credentials.secret_key
  alias = "main"
}

provider "google" {
  credentials = local.google_credentials.service_account_credentials
  project = local.google_credentials.project
  region  = local.google_credentials.region
  zone    = local.google_credentials.zone
  alias = "google_cloud_storage"
}

