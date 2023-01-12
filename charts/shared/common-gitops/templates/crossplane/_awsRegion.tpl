{{/* vim: set filetype=mustache: */}}
{{/*
Render the region value for AWS resource:
Accepts dict:
{
  root: [map] - root context
  kind: [string] - resource kind name, e.g. "Policy"
  name: [string] - item id, e.g. "argocd"
}
Sample return:
region: us-west-1

*/}}
{{- define "common-gitops.crossplane.awsRegion" -}}
  {{- $kindObj := (index .root.Values .kind) -}}
  {{- $item := (index $kindObj.items .name) -}}
  {{- /* Take the first non-empty argument */ -}}
region: {{ coalesce  ($item.forProvider).region
                     $kindObj.region
                     (.root.Values.global).awsRegion
                     "us-west-2" }}
{{- end -}}
