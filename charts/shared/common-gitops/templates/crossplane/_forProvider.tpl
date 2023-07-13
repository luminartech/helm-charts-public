{{/* vim: set filetype=mustache: */}}
{{/*
Render the forProvider dictionary.
Accepts dict:
{
  root: [map] - root context
  values: [dict] - .forProvider value
  valuesOverride: [dict] - .forProvider values to override
}
Sample return:
forProvider: {}
*/}}
{{- define "common-gitops.crossplane.forProvider" -}}
  {{- include "common-gitops.tplvalues.render" (dict
    "value" (dict "forProvider" (merge (.valuesOverride) (.values)))
    "context" .root) }}
{{- end -}}
