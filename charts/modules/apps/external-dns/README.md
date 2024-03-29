# External-dns Module Chart

## TL;DR

## Introduction

## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+

## Using the Chart

## Parameters

### Global parameters

| Name                            | Description                                                                                                 | Value                            |
| ------------------------------- | ----------------------------------------------------------------------------------------------------------- | -------------------------------- |
| `global.chartNameOverride`      | Overrides the chart name.                                                                                   | `""`                             |
| `global.releaseNameOverride`    | Overrides the release name.                                                                                 | `""`                             |
| `global.tags`                   | Define common tags for all IAC and app resources generated by this chart.                                   | `{}`                             |
| `global.labels`                 | Define common labels for all IAC and app resources generated by this chart.                                 | `{}`                             |
| `global.annotations`            | Define common annotations for all IAC and app resources generated by this chart.                            | `{}`                             |
| `global.providerConfigRef.name` | Default crossplane provider all resources generated for crossplane.                                         | `crossplane-provider-config-aws` |
| `global.awsAccountId`           | Default aws account id for crossplane aws provider resources. Quotes are important, value must be a string. | `0123456789`                     |
| `global.awsRegion`              | Default aws region for crossplane aws provider resources.                                                   | `us-west-2`                      |
| `global.eksHash`                | Default EKS cluster hash for relevant crossplane resources such as IAM Role.                                | `XXXXX`                          |
| `global.deploymentName`         | Deployment name used as fullnameoverride for upstream chart.                                                | `external-dns`                   |


## Configuration and installation details


## Troubleshooting


## Notable changes
