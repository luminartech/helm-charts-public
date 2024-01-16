{{/* vim: set filetype=mustache: */}}
{{/* Kubernetes standard labels */}}
{{- define "common-gitops.labels.standard" -}}
labels:
  app.kubernetes.io/component: {{ include "common-gitops.names.chart" .root }}
  helm.sh/chart: {{ include "common-gitops.names.chart" .root }}-{{ .root.Chart.Version }}
  app.kubernetes.io/part-of: {{ include "common-gitops.names.release" .root }}
  app.kubernetes.io/managed-by: {{ .root.Release.Service }}
  app.kubernetes.io/instance: "{{ include "common-gitops.names.itemId" (dict "value" .name "root" .root) }}"
{{- end -}}
{{/*
Generate labels map based on values set on global, resource kind and resource item levels.
Input dict:
{
  root: [map] - root context
  kind: [string] - resource kind name, e.g. "Policy"
  name: [string] - item id, e.g. "argocd"
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
  app.kubernetes.io/instance: "{{ include "common-gitops.names.itemId" (dict "value" .name "root" .root) }}"
  {{- $kindObj := (index .root.Values .kind) -}}
  {{- $item := (index $kindObj.items .name) -}}
  {{- /* Left argument takes precedence over the right one */ -}}
  {{- with merge ($item.labels)
                 ($kindObj.labels)
                 ((.root.Values.global).labels) -}}
    {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $.root) | nindent 2 }}
  {{- end -}}
{{- end -}}
