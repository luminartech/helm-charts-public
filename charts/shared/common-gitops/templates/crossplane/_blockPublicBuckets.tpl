{{/* vim: set filetype=mustache: */}}
{{/*
Render the restrictPublicBuckets value for AWS resource:
Accepts dict:
{
  root: [map] - root context
  kind: [string] - resource kind name, e.g. "Policy"
  name: [string] - item id, e.g. "argocd"
}
Sample return:
us-west-1

*/}}
{{- define "common-gitops.crossplane.blockPublicBuckets" -}}
  {{- $kindObj := (index .root.Values .kind) -}}
  {{- $item := (index $kindObj.items .name) -}}
  {{- /* Take the first non-empty argument */ -}}
  {{- coalesce ($item.forProvider).restrictPublicBuckets
               $kindObj.restrictPublicBuckets
               ($item.forProvider).blockPublicAcls
               $kindObj.blockPublicAcls
               ($item.forProvider).blockPublicPolicy
               $kindObj.blockPublicPolicy
               (.root.Values.global).awsBlockBucketPublic
               "true" }}
{{- end -}}
