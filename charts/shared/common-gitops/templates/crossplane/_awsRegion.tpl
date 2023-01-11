{{/* vim: set filetype=mustache: */}}
{{/*
Render the region value for AWS resource:
Accepts dict:
{
  root: [dict] .
  kind: [dict] "Policy"
  name: [string] "item1"
}
Sample return:
region: us-west-1

*/}}
{{- define "common-gitops.crossplane.awsRegion" -}}
  {{- $kindObj := (index .root.Values .kind) -}}
  {{- $item := (index $kindObj.items .name) -}}
region: {{ coalesce  ($item.forProvider).region
                     $kindObj.region
                     (.root.Values.global).awsRegion
                     "us-west-2" }}
{{- end -}}
