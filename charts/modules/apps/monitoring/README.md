
# Monitoring Module Chart

## TL;DR

## Introduction

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Using the Chart

1. Get or update the Grafana dashboard setting as json in [`utils/grafana-dashboards/`](utils/grafana-dashboards/).
2. Run `./utils/sync_grafana_dashboards.py` to generate the [yaml templates](templates/grafana/dashboards-1.14/) from the json files.
3. Commit both to version control.

## Parameters

### commonGrafanaDashboards




### kube-prometheus-stack


















## Configuration and installation details


## Troubleshooting


## Notable changes
