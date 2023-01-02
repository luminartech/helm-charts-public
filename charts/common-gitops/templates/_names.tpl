{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "common-gitops.names.chart" -}}
  {{- with (.Values.global).chartNameOverride -}}
    {{- include "common-gitops.utils.validateLength" . -}}
  {{- else -}}
    {{- include "common-gitops.utils.validateLength" .Chart.Name -}}
  {{- end -}}
{{- end -}}

{{/*
Create a fully qualified app name.
*/}}
{{- define "common-gitops.names.release" -}}
  {{- with (.Values.global).releaseNameOverride -}}
    {{- include "common-gitops.utils.validateLength" (
      include "common-gitops.tplvalues.render" (dict "value" . "context" $)) -}}
  {{- else -}}
    {{- include "common-gitops.utils.validateLength" .Release.Name -}}
  {{- end -}}
{{- end -}}

{{/*
Build an item name (release + item name) for gitops entity (item)
Example usage: {{ include "common-gitops.names.itemFullname" (dict "name" $name "root" .) }}
Input:
  .name (optional) - short name of the item
  .override - will overrdie the generated name if defined
  .root - Context
Example output:
  iac-cicd-karpenter-provisioner-linux-x86-cpu-medium
*/}}

{{- define "common-gitops.names.itemFullname" -}}
  {{- with .override -}}
    {{- include "common-gitops.utils.validateLength" (
      include "common-gitops.tplvalues.render" (dict "value" . "context" $.root)) -}}
  {{- else -}}
    {{- include "common-gitops.utils.validateLength" (
        printf "%s-%s"
          (include "common-gitops.names.release" .root)
          (include "common-gitops.names.itemId" .name) |
        trimSuffix "-") -}}
  {{- end -}}
{{- end -}}

{{/*
"_" means "empty" name and this character gets truncated from the output.
Use when you would like item's fullanme be equal to the Release.Name.
For example, allows to get "cicd-infra-vpc" instead of "cicd-infra-vpc-vpc".
*/}}
{{- define "common-gitops.names.itemId" -}}
  {{- . | trimSuffix "_" -}}
{{- end -}}

{{/*
Allow the release namespace to be overridden for multi-namespace deployments in combined charts.
*/}}
{{- define "common-gitops.names.namespace" -}}
  {{- with .Values.global.namespaceOverride -}}
    {{- . -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}
