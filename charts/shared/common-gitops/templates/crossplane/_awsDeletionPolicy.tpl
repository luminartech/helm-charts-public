{{/* vim: set filetype=mustache: */}}
{{/*
Render the deletionPolicy value for AWS resource:
Accepts dict:
{
  root: [dict] .
  kind: [dict] "Policy"
  name: [string] "item1"
}
Sample return:
deletionPolicy: Orphan

*/}}
{{- define "common-gitops.crossplane.awsDeletionPolicy" -}}
  {{- $kindObj := (get .root.Values .kind) -}}
  {{- $item := (get $kindObj.items .name) -}}
deletionPolicy: {{ coalesce $item.deletionPolicy
                            $kindObj.deletionPolicy
                            .root.Values.deletionPolicy
                            (.root.Values.global).awsDeletionPolicy
                            "Orphan" }}
{{- end -}}
