{{/* vim: set filetype=mustache: */}}
{{/* Create publishConnectionDetailsTo value for Crossplane resource
Input dict:
{
  root: [map] - root context
  kind: [string] - resource kind name, e.g. "Policy"
  name: [string] - item id, e.g. "argocd"
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
  {{- $kindObj := (index $root.Values $kind) -}}
  {{- $item := (index $kindObj.items $name) -}}
  {{- /* Left argument takes precedence over the right one */ -}}
  {{- with merge ($item.publishConnectionDetailsTo)
                 ($kindObj.publishConnectionDetailsTo)
                 (($root.Values.global).publishConnectionDetailsTo) -}}
    {{- if .enabled -}}
publishConnectionDetailsTo:
  name: {{ include "common-gitops.tplvalues.render" (dict "value" .name "context" $root) |
    default (include "common-gitops.names.itemFullname" (dict "root" $root "name" $name "override" $.nameOverride)) }}
      {{- with .configRef }}
  configRef:
        {{- with .name }}
    name: {{ include "common-gitops.tplvalues.render" (dict "value" . "context" $root) }}
        {{ else -}}
    name: default
        {{ end -}}
        {{- with .policy }}
    policy:
          {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $root) | nindent 6 -}}
        {{- end -}}
      {{- end -}}
      {{- with .metadata }}
  metadata:
        {{- include "common-gitops.labels" (dict "root" $root "name" $name "kind" $kind) | nindent 4 -}}
        {{- /* Left argument takes precedence over the right one */ -}}
        {{- with merge (.annotations)
                       (($root.Values.global).annotations) }}
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
