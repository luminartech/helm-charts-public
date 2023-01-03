{{/* vim: set filetype=mustache: */}}
{{/* Kubernetes standard labels */}}
{{- define "common-gitops.labels.standard" -}}
labels:
  app.kubernetes.io/component: {{ include "common-gitops.names.chart" .root }}
  helm.sh/chart: {{ include "common-gitops.names.chart" .root }}-{{ .root.Chart.Version }}
  app.kubernetes.io/part-of: {{ include "common-gitops.names.release" .root }}
  app.kubernetes.io/managed-by: {{ .root.Release.Service }}
  app.kubernetes.io/instance: "{{ include "common-gitops.names.itemId" .name }}"
{{- end -}}
{{/*
Common labels for gitops resources
Input dict:
{
  root: [map] .
  kind: [map] "Policy"
  name: [string] item1
}
Sample return:
labels:
  shortName: "test"
*/}}
{{- define "common-gitops.labels" -}}
labels:
  app.kubernetes.io/component: {{ include "common-gitops.names.chart" .root }}
  helm.sh/chart: {{ include "common-gitops.names.chart" .root }}-{{ .root.Chart.Version }}
  app.kubernetes.io/part-of: {{ include "common-gitops.names.release" .root }}
  app.kubernetes.io/managed-by: {{ .root.Release.Service }}
  app.kubernetes.io/instance: "{{ include "common-gitops.names.itemId" .name }}"
  {{- $kindObj := (get .root.Values .kind) -}}
  {{- $item := (get $kindObj.items .name) -}}
  {{- $mergedLabels := mergeOverwrite ((.root.Values.global).labels)
                            ($kindObj.labels)
                            ($item.labels) -}}
  {{- with $mergedLabels -}}
    {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $.root) | nindent 2 }}
  {{- end -}}
{{- end -}}
