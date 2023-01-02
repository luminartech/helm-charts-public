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
  {{- $kindObj := (get .root.Values .kind) -}}
  {{- $item := (get $kindObj.items .name) -}}
  {{- with mergeOverwrite ((.root.Values.global).annotations)
                           ($kindObj.annotations)
                           ($item.annotations) -}}
annotations:
    {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $.root) | nindent 2 -}}
  {{- end -}}
{{- end -}}
