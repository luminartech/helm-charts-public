{{/* vim: set filetype=mustache: */}}
{{/* writeConnectionSecretToRef template
Input dict:
{
  root: [map] - root context
  kind: [string] - resource kind name, e.g. "Policy"
  name: [string] - item id, e.g. "argocd"
}
Sample return:
writeConnectionSecretToRef:
  name: "test"
  namespace: "infra-crossplane"
*/}}
{{- define "common-gitops.crossplane.writeConnectionSecretToRef" -}}
  {{- $root := .root -}}
  {{- $kind := .kind -}}
  {{- $name := .name -}}
  {{- $kindObj := (index .root.Values $kind) -}}
  {{- $item := (index $kindObj.items $name) -}}
  {{- /* Left argument takes precedence over the right one */ -}}
  {{- with merge ($item.writeConnectionSecretToRef)
                 ($kindObj.writeConnectionSecretToRef)
                 (($root.Values.global).writeConnectionSecretToRef) -}}
    {{- if .enabled }}
writeConnectionSecretToRef:
      {{- with .name }}
  name: {{ include "common-gitops.tplvalues.render" (dict "value" . "context" $root) | quote }}
      {{- else }}
  name: {{ include "common-gitops.names.itemFullname" (dict "root" $root "name" $name "override" $.nameOverride) | quote }}
      {{- end }}
      {{- with .namespace }}
  namespace: {{ include "common-gitops.tplvalues.render" (dict "value" . "context" $root) | quote }}
      {{- else }}
  namespace: "infra-crossplane"
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
