{{/* vim: set filetype=mustache: */}}
{{/* Reference fields set template

Some objects may refer to others by using the fields like "policyArn", "policyArnRef" and "policyArnSelector".
Only one such field is expected to be set at the same time.
Some objects require reference to be defined, some are optional.
There's also a slight variation of the names for those fields.

Input dict:
{
  root: [map] $root
  context: [map] .
  optional: [bool, optional] - do not throw an error if none of "field", "fieldRef" or "fieldSelector is set
  field: [string] policyArn
  fieldRef: [string, optional] - name of Ref field. If not set, .field + "Ref" will be used
  fieldSelector: [string, optional] - name of Selector field. If not set, .field + "Selector" will be used
}
Sample return:

policyArnRef:
  name: test
*/}}
{{- define "common-gitops.crossplane.reference" -}}
  {{- $fieldRef := empty .fieldRef | ternary (print .field "Ref") .fieldRef -}}
  {{- $fieldSelector := empty .fieldSelector | ternary (print .field "Selector") .fieldSelector -}}
  {{- $fieldObj := index .context .field -}}
  {{- $fieldRefObj := index .context $fieldRef -}}
  {{- $fieldSelectorObj := index .context $fieldSelector -}}
  {{- if $fieldRefObj -}}
{{ $fieldRef }}:
    {{- include "common-gitops.tplvalues.render" (dict "value" $fieldRefObj "context" .root) | nindent 2 -}}
  {{- else if $fieldSelectorObj -}}
{{ $fieldSelector }}:
    {{- include "common-gitops.tplvalues.render" (dict "value" $fieldSelectorObj "context" .root) | nindent 2 -}}
  {{- else if $fieldObj -}}
{{ .field }}: "{{ include "common-gitops.tplvalues.render" (dict "value" $fieldObj "context" .root) }}"
  {{- else if not .optional -}}
{{ .field }}: "{{ $fieldObj | required (print .field " is required") }}"
  {{- end -}}
{{- end -}}
