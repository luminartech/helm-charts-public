{{/* vim: set filetype=mustache: */}}
{{/*
Create the name of the chart.
*/}}
{{- define "common-gitops.names.chart" -}}
  {{- with (.Values.global).chartNameOverride -}}
    {{- include "common-gitops.utils.validateLength" . -}}
  {{- else -}}
    {{- include "common-gitops.utils.validateLength" .Chart.Name -}}
  {{- end -}}
{{- end -}}

{{/*
Create a release name.
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
Build a fully qualified name (release + item id/short name) for gitops resource item.
Example usage: {{ include "common-gitops.names.itemFullname" (dict "name" $name "root" .) }}
Input:
  .name (optional) - short name of the item
  .override (optional) - will overrdie the generated name if defined
  .root - Root context
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
Process the resource item Id (short name).
"_" is used to define an "empty" name since empty string ("") is not supported by K8s.
We still want his character to get truncated from the fullnames and perhaps extend the list of transformations later.
Use "_" when there's only one item of particular kind in deployment and you would like item's fullanme be equal to the Release.Name.
For example, allows to avoid word duplication in item name - "cicd-infra-vpc" instead of "cicd-infra-vpc-vpc".
*/}}
{{- define "common-gitops.names.itemId" -}}
  {{- . | trimSuffix "_" -}}
{{- end -}}

{{/*
Create a namespace value.
Allow the release namespace to be overridden for multi-namespace deployments in combined charts.
*/}}
{{- define "common-gitops.names.namespace" -}}
  {{- with .Values.global.namespaceOverride -}}
    {{- . -}}
  {{- else -}}
    {{- .Release.Namespace -}}
  {{- end -}}
{{- end -}}
