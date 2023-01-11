{{/* vim: set filetype=mustache: */}}
{{/*
Annotations template.

Input dict:
{
  root: [map] .
  kind: [map] "Policy"
  name: [string] name
}
Sample return:
annotations:
  my-annotation: something-here
*/}}
{{- define "common-gitops.annotations" -}}
  {{- $kindObj := (index .root.Values .kind) -}}
  {{- $item := (index $kindObj.items .name) -}}
  {{- with merge ($item.annotations)
                 ($kindObj.annotations)
                 ((.root.Values.global).annotations) -}}
annotations:
    {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $.root) | nindent 2 -}}
  {{- end -}}
{{- end -}}
