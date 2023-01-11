{{/* vim: set filetype=mustache: */}}
{{/* writeConnectionSecretToRef template
Input dict:
{
  root: [map] .
  kind: [map] "Policy"
  name: [string] item1
}
Sample return:
writeConnectionSecretToRef:
  name: "test"
  namespace: "infra-crossplane"
*/}}
{{- define "common-gitops.crossplane.writeConnectionSecretToRef" -}}
  {{- $kindObj := (index .root.Values .kind) -}}
  {{- $item := (index $kindObj.items .name) -}}
  {{- with merge ($item.writeConnectionSecretToRef)
                 ($kindObj.writeConnectionSecretToRef)
                 ((.root.Values.global).writeConnectionSecretToRef) -}}
    {{- if .enabled }}
writeConnectionSecretToRef:
  name: {{ include "common-gitops.names.itemFullname" (dict "root" $.root "name" $.name "override" $.nameOverride) }}
  namespace: {{ .namespace | default "infra-crossplane" }}
    {{- end -}}
  {{- end -}}
{{- end -}}
