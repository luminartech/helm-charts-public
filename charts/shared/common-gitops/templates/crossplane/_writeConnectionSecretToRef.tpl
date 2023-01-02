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
  {{- $kindObj := (get .root.Values .kind) -}}
  {{- $item := (get $kindObj.items .name) -}}
  {{- with (mergeOverwrite ((.root.Values.global).writeConnectionSecretToRef)
                            ($kindObj.writeConnectionSecretToRef)
                            ($item.writeConnectionSecretToRef)) -}}
    {{- if .enabled }}
writeConnectionSecretToRef:
  name: {{ include "common-gitops.names.itemFullname" (dict "root" $.root "name" $.name "override" $.nameOverride) }}
  namespace: {{ .namespace | default "infra-crossplane" }}
    {{- end -}}
  {{- end -}}
{{- end -}}
