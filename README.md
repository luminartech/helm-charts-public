# Helm-charts-public

Luminar public helm charts.

## How do I make a chage?

1. Update or create a new chart (module) in `/charts` and send a PR. Make sure that in case of update `version` field is updated in Chart.yaml - GitHub Action rilies on it.
2. Once PR is merged, the GitHub Action will package and publish chart to GitHub Packages - https://github.com/orgs/luminartech/packages?visibility=pubilc. Usually it takes about a minute.
3. Update your helm chart reference.
