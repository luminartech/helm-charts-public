{{/* vim: set filetype=mustache: */}}
{{/* Create providerConfigRef value for Crossplane resource.
Input dict:
{
  root: [map] - root context
  kind: [string] - resource kind name, e.g. "Policy"
  name: [string] - item id, e.g. "argocd"
}
Sample return:
providerConfigRef:
  name: default
*/}}
{{- define "common-gitops.crossplane.providerConfigRef" -}}
  {{- $kindObj := (index (.root.Values) .kind) -}}
  {{- $item := (index $kindObj.items .name) -}}
providerConfigRef:
  {{- /* Left argument takes precedence over the right one */ -}}
  {{- with merge ($item.providerConfigRef)
                 ($kindObj.providerConfigRef)
                 ((.root.Values.global).providerConfigRef) -}}
    {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $.root) | nindent 2 }}
  {{- else }}
  name: default
  {{- end -}}
{{- end -}}
