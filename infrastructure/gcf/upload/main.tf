data "archive_file" "source_code" {
  type        = "zip"
  output_path = "/tmp/${var.project}-gcf-${var.function_name}.zip"
  source_dir = "../components/${var.source_dir}"
}

resource "google_storage_bucket_object" "archive" {
  name   = "${var.function_name}-${filemd5("/tmp/${var.project}-gcf-${var.function_name}.zip")}.zip"
  bucket = var.bucket
  source = "/tmp/${var.project}-gcf-${var.function_name}.zip"
  depends_on = [data.archive_file.source_code]
}
