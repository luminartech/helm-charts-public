{{/* vim: set filetype=mustache: */}}
{{/* Renders a value that contains template.
Input dict:
{
    value: [map or string] - template
    context: [map] - root context
    trimEmpty: [bool, optional] - if true, empty values will be trimmed. Useful when empty dict or list in the output should be avoided.
}
Usage:
{{ include "common-gitops.tplvalues.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "common-gitops.tplvalues.render" -}}
    {{- if typeIs "string" .value -}}
        {{- tpl .value .context -}}
    {{- else -}}
        {{ if and .trimEmpty (not .value) -}}
        {{- else -}}
            {{- tpl (.value | toYaml) .context | trim -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
