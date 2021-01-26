resource "google_monitoring_dashboard" "dashboard" {
  dashboard_json = <<EOF
{
  "displayName": "News feed monitoring dashboard",
  "mosaicLayout": {
    "columns": 12,
    "tiles": [
      {
        "width": 6,
        "height": 4,
        "widget": {
          "title": "Cloud Functions info/warning/error log lines #",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"logging.googleapis.com/user/gcf_info_lines\" resource.type=\"cloud_function\"",
                    "aggregation": {
                      "perSeriesAligner": "ALIGN_SUM",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "resource.label.\"project_id\""
                      ]
                    },
                    "secondaryAggregation": {}
                  }
                },
                "plotType": "LINE",
                "legendTemplate": "info",
                "minAlignmentPeriod": "60s"
              },
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"logging.googleapis.com/user/gcf_warn_lines\" resource.type=\"cloud_function\"",
                    "aggregation": {
                      "perSeriesAligner": "ALIGN_SUM",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "resource.label.\"project_id\""
                      ]
                    },
                    "secondaryAggregation": {}
                  }
                },
                "plotType": "LINE",
                "legendTemplate": "warn",
                "minAlignmentPeriod": "60s"
              },
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"logging.googleapis.com/user/gcf_error_lines\" resource.type=\"cloud_function\"",
                    "aggregation": {
                      "perSeriesAligner": "ALIGN_SUM",
                      "crossSeriesReducer": "REDUCE_SUM",
                      "groupByFields": [
                        "resource.label.\"project_id\""
                      ]
                    },
                    "secondaryAggregation": {}
                  }
                },
                "plotType": "LINE",
                "legendTemplate": "error",
                "minAlignmentPeriod": "60s"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 6,
        "width": 6,
        "height": 4,
        "widget": {
          "title": "Frontend requests/min",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"cloudfunctions.googleapis.com/function/execution_count\" resource.type=\"cloud_function\" resource.label.\"function_name\"=monitoring.regex.full_match(\"frontend-api-eu|frontend-api-us\")",
                    "aggregation": {
                      "perSeriesAligner": "ALIGN_SUM"
                    },
                    "secondaryAggregation": {}
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 8,
        "yPos": 8,
        "width": 4,
        "height": 4,
        "widget": {
          "title": "Unprocessed pub/sub messages",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"pubsub.googleapis.com/subscription/num_undelivered_messages\" resource.type=\"pubsub_subscription\"",
                    "aggregation": {
                      "perSeriesAligner": "ALIGN_MEAN"
                    }
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 6,
        "yPos": 4,
        "width": 6,
        "height": 4,
        "widget": {
          "title": "News added count per minute",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"logging.googleapis.com/user/news_count\" resource.type=\"cloud_function\"",
                    "aggregation": {
                      "perSeriesAligner": "ALIGN_DELTA"
                    },
                    "secondaryAggregation": {}
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "yPos": 4,
        "width": 6,
        "height": 4,
        "widget": {
          "title": "Cloud Function - Execution times [95TH PERCENTILE]",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"cloudfunctions.googleapis.com/function/execution_times\" resource.type=\"cloud_function\"",
                    "aggregation": {
                      "perSeriesAligner": "ALIGN_PERCENTILE_95"
                    },
                    "secondaryAggregation": {}
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "yPos": 8,
        "width": 4,
        "height": 4,
        "widget": {
          "title": "Successful Cloud Functions executions per minute",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"cloudfunctions.googleapis.com/function/execution_count\" resource.type=\"cloud_function\" metric.label.\"status\"=\"ok\"",
                    "aggregation": {
                      "perSeriesAligner": "ALIGN_SUM"
                    },
                    "secondaryAggregation": {}
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      },
      {
        "xPos": 4,
        "yPos": 8,
        "width": 4,
        "height": 4,
        "widget": {
          "title": "Failed Cloud Functions executions per minute",
          "xyChart": {
            "dataSets": [
              {
                "timeSeriesQuery": {
                  "timeSeriesFilter": {
                    "filter": "metric.type=\"cloudfunctions.googleapis.com/function/execution_count\" resource.type=\"cloud_function\" metric.label.\"status\"!=\"ok\"",
                    "aggregation": {
                      "perSeriesAligner": "ALIGN_SUM"
                    },
                    "secondaryAggregation": {}
                  }
                },
                "plotType": "LINE",
                "minAlignmentPeriod": "60s"
              }
            ],
            "timeshiftDuration": "0s",
            "yAxis": {
              "label": "y1Axis",
              "scale": "LINEAR"
            },
            "chartOptions": {
              "mode": "COLOR"
            }
          }
        }
      }
    ]
  }
}
EOF
}
