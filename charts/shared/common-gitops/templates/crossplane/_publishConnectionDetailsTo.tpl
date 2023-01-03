{{/* vim: set filetype=mustache: */}}
{{/* publishConnectionDetailsTo template
Input dict:
{
  root: [map] .
  kind: [map] "Policy"
  name: [string] item1
}
Sample return:
publishConnectionDetailsTo:
  name: default
  metadata:
    annotations:
      test: one
*/}}
{{- define "common-gitops.crossplane.publishConnectionDetailsTo" -}}
  {{- $root := .root -}}
  {{- $kind := .kind -}}
  {{- $name := .name -}}
  {{- $kindObj := (get $root.Values $kind) -}}
  {{- $item := (get $kindObj.items $name) -}}
  {{- with (mergeOverwrite (($root.Values.global).publishConnectionDetailsTo)
                            ($kindObj.publishConnectionDetailsTo)
                            ($item.publishConnectionDetailsTo)) -}}
    {{- if .enabled -}}
publishConnectionDetailsTo:
  name: {{ include "common-gitops.names.itemFullname" (dict "root" $root "name" $name "override" $.nameOverride) }}
      {{- with .configRef }}
  configRef:
    name: {{ include "common-gitops.tplvalues.render" (dict "value" .name "context" $root) | default "default" }}
        {{- with .policy }}
    policy:
          {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $root) | nindent 6 -}}
        {{- end -}}
      {{- end -}}
      {{- with .metadata }}
  metadata:
        {{- include "common-gitops.labels" (dict "root" $root "name" $name "kind" $kind) | nindent 4 -}}
        {{- with (mergeOverwrite (($root.Values.global).annotations) (.annotations)) }}
    annotations:
          {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $root) | nindent 6 -}}
        {{- end -}}
        {{- with .type }}
    type: {{ . | quote }}
        {{- end -}}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
