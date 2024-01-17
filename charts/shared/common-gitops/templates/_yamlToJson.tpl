{{/* vim: set filetype=mustache: */}}
{{/*
Render the Json from Yaml with support of templating in input.
4 spaces are used for indentation as it's preffered by AWS
Accepts dict:
{
  root: [map] - root context
  value: [string or dict] - policy
}
Important note. JSON can be provided in 3 mutually exclusive formats:
- raw Json (string)
- yaml that is exact representation of Json
See values-test.yaml for examples.
Sample return:
{
    "key1": "value1",
    "key2": "value2",
}
*/}}
{{- define "common-gitops.yamlToJson" -}}
  {{- if .value -}}
    {{- if kindIs "string" .value -}}
      {{ include "common-gitops.tplvalues.render" (dict "value" .value "context" .root) }}
    {{- else if kindIs "map" .value -}}
      {{ include "common-gitops.tplvalues.render" (dict "value" .value "context" .root) |
        fromYaml |
        mustToPrettyJson |
        replace "  " "    " -}}
    {{- else -}}
      {{- fail (print "Unsupported type of JSON document: " (kindOf .value)) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
