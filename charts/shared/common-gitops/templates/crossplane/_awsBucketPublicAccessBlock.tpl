{{/* vim: set filetype=mustache: */}}
{{/*
Render the restrictPublicBuckets, blockPublicAcls, blockPublicPolicy value for AWS resource:
Accepts dict:
{
  root: [map] - root context
  kind: [string] - resource kind name, e.g. "BucketPublicAccessBlock"
  name: [string] - item id, e.g. "<bucket_alias>"
}
Sample return boolean:
true

Global Override:
awsBlockBucketPublic: "false"

Sample Local Override: (Enclose value in double quotes)
restrictPublicBuckets: "false"

*/}}
{{- define "common-gitops.crossplane.blockPublicBuckets" -}}
  {{- $kindObj := (index .root.Values .kind) -}}
  {{- $item := (index $kindObj.items .name) -}}
  {{- /* Take the first non-empty argument */ -}}
  {{- coalesce (index $item.forProvider .blockType)
               (index $kindObj .blockType)
               (.root.Values.global).awsBlockBucketPublic
               "true" }}
{{- end -}}
