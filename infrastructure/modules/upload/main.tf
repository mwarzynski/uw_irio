locals {
  zip_file = "/tmp/${var.project}-gcf-${var.function_name}.zip"
}

data "archive_file" "source_code" {
  type        = "zip"
  output_path = local.zip_file
  source_dir = "../components/${var.source_dir}"
}

resource "google_storage_bucket_object" "archive" {
  name   = "${var.function_name}-${filemd5(local.zip_file)}.zip"
  bucket = var.bucket
  source = local.zip_file
  depends_on = [data.archive_file.source_code]
}
