# Helm-charts-public

Luminar public helm charts.

## How do I make a chage?

1. Update or create a new chart (module) in `/charts` and send a PR. Make sure that `version` field in Chart.yaml is updated accordingly since GitHub Action relies on it (see [Helm chrats version pattern](#helm-chrats-version-pattern)).
2. Once PR is merged, the GitHub Action will release chart to GitHub Packages - https://github.com/orgs/luminartech/packages?visibility=pubilc. Usually it takes about a minute.
3. Update any helm chart reference(s).

## Helm chrats version pattern

### appVersion field

It equals to the version of the main upstream dependency chart.
E.g. for karpenter chart with:

```
	...
	dependencies:
	  - name: karpenter
	    version: "v0.33.2"
	    repository: "oci://public.ecr.aws/karpenter"
	    condition: karpenter.enabled
	...
```

it will be `0.33.2`.

Upstream application version may be used as well, though it's not always possible. For instance, corssplane-aws-* charts may be used with multiple different versions of Crossplane provider and in such case latest tested version is used.

### version field

Contains the value of `appVersion` with helm chart release number suffix - `appVersion-X`, i.e. `0.33.2-0`.

Release number always starts with 0.

Version increment is required to trigger a pipeline that releases chart to repository on GitHub Container Registry. In other words, any change to helm chart should pair up with update of `version` field in Chart.yaml.
