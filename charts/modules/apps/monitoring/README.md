# Kubernetes Prometheus Stack

### Update the Dashboard

1. Get or update the Grafana dashboard setting as json in [`utils/grafana-dashboards/`](utils/grafana-dashboards/).
1. Run `./utils/sync_grafana_dashboards.py` to generate the [yaml templates](templates/grafana/dashboards-1.14/) from the json files.
1. Commit both to version control.
