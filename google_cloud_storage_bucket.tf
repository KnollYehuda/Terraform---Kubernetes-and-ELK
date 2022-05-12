resource "google_storage_bucket" "terraform_google_storage_bucket" {
  provider = google.google_cloud_storage
  name          = local.google_cloud_storage_bucket_options.bucket_name
  location      = local.google_credentials.region
  force_destroy = local.google_cloud_storage_bucket_options.force_destroy
  storage_class = local.google_cloud_storage_bucket_options.storage_class
}
