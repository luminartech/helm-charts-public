{{/* vim: set filetype=mustache: */}}
{{/*
Generate annotations map based on values set on global, resource kind and resource item levels.

Input dict:
{
  root: [map] - root context
  kind: [string] - resource kind name, e.g. "Policy"
  name: [string] - item id, e.g. "argocd"
}
Sample return:
annotations:
  my-annotation: something-here
*/}}
{{- define "common-gitops.annotations" -}}
  {{- $kindObj := (index .root.Values .kind) -}}
  {{- $item := (index $kindObj.items .name) -}}
  {{- /* Left argument takes precedence over the right one */ -}}
  {{- with merge ($item.annotations)
                 ($kindObj.annotations)
                 ((.root.Values.global).annotations) -}}
annotations:
    {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $.root) | nindent 2 -}}
  {{- end -}}
{{- end -}}
