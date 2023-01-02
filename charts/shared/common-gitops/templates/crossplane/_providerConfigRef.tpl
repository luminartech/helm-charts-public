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
  {{- $kindObj := (get (.root.Values) .kind) -}}
  {{- $item := (get $kindObj.items .name) -}}
providerConfigRef:
  {{- with (mergeOverwrite (((.root.Values).global).providerConfigRef)
                            ($kindObj.providerConfigRef)
                            ($item.providerConfigRef)) -}}
    {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $.root) | nindent 2 }}
  {{- else }}
  name: default
  {{- end -}}
{{- end -}}
