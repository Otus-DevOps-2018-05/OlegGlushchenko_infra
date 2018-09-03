terraform {
  backend "gcs" {
    bucket = "storage-bucket-ol-test-1"
    prefix = "terraform/state"
  }
}
