{{/* vim: set filetype=mustache: */}}
{{/* Generate Crossplane reference fields set

Handle the Crossplane resources reference fields since they are always set of three, e.g. "policyArn", "policyArnRef" and "policyArnSelector",
and only one can be set at the same time while reference itself being required or optional.

Input dict:
{
  root: [map] - global context
  context: [map] - current context from which reference fields should be accesible
  optional: [bool, optional] - make reference optional, i.e. do not throw an error if none of "field", "fieldRef" or "fieldSelector is set
  field: [string] - name of the first field, e.g. "policyArn"
  fieldRef: [string, optional] - name of Ref field. First field name + "Ref" is a default value. Since not all Crossplane reference fields follow the same naming pattern, we might want to override these field name.
  fieldSelector: [string, optional] - name of Selector field. First field name + "Selector" is a default value. Since not all Crossplane reference fields follow the same naming pattern, we might want to override these field name.
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
