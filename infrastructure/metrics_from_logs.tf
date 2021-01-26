resource "google_logging_metric" "error_lines_metric" {
  name   = "gcf_error_lines"
  filter = "resource.type=cloud_function severity=(EMERGENCY OR ALERT OR CRITICAL OR ERROR)"
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}

resource "google_logging_metric" "info_lines_metric" {
  name   = "gcf_info_lines"
  filter = "resource.type=cloud_function severity=INFO"
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}

resource "google_logging_metric" "warn_lines_metric" {
  name   = "gcf_warn_lines"
  filter = "resource.type=cloud_function severity=WARNING"
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}

resource "google_logging_metric" "news_count_metric" {
  name   = "news_count"
  filter = "resource.type=cloud_function severity=INFO textPayload =~ \"news \\(id=.*\\) set in database\""
  metric_descriptor {
    metric_kind = "DELTA"
    value_type  = "INT64"
  }
}
