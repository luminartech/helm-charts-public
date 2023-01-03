{{/* vim: set filetype=mustache: */}}
{{/* Renders a value that contains template.
Input dict:
{
    value: [map or string]
    context: $
}
Usage:
{{ include "common-gitops.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "common-gitops.tplvalues.render" -}}
    {{- if typeIs "string" .value -}}
        {{- tpl .value .context }}
    {{- else -}}
        {{- tpl (.value | toYaml) .context }}
    {{- end -}}
{{- end -}}
