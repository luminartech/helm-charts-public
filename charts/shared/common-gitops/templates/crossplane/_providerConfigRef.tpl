{{/* vim: set filetype=mustache: */}}
{{/* providerConfigRef template
Input dict:
{
  root: [map] .
  kind: [map] "Policy"
  name: [string] item1
}
Sample return:
providerConfigRef:
  name: default
*/}}
{{- define "common-gitops.crossplane.providerConfigRef" -}}
  {{- $kindObj := (index (.root.Values) .kind) -}}
  {{- $item := (index $kindObj.items .name) -}}
providerConfigRef:
  {{- with merge ($item.providerConfigRef)
                 ($kindObj.providerConfigRef)
                 ((.root.Values.global).providerConfigRef) -}}
    {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $.root) | nindent 2 }}
  {{- else }}
  name: default
  {{- end -}}
{{- end -}}
