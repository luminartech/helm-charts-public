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
                 ((.root.Values.global).writeConnectionSecretToRef) -}}
    {{- if .enabled }}
writeConnectionSecretToRef:
  name: {{ include "common-gitops.tplvalues.render" (dict "value" .name "context" $root) |
    default (include "common-gitops.names.itemFullname" (dict "root" $root "name" $name "override" $.nameOverride)) }}
  namespace: {{ include "common-gitops.tplvalues.render" (dict "value" .namespace "context" $root) |
    default "infra-crossplane" }}
    {{- end -}}
  {{- end -}}
{{- end -}}
