{{/* vim: set filetype=mustache: */}}
{{/*
Render the deletionPolicy value for crossplane resource:
Accepts dict:
{
  root: [map] - root context
  kind: [string] - resource kind name, e.g. "Policy"
  name: [string] - item id, e.g. "argocd"
}
Sample return:
deletionPolicy: Orphan
*/}}
{{- define "common-gitops.crossplane.deletionPolicy" -}}
  {{- $kindObj := (index .root.Values .kind) -}}
  {{- $item := (index $kindObj.items .name) -}}
  {{- /* Take the first non-empty argument */ -}}
deletionPolicy: {{ coalesce $item.deletionPolicy
                            $kindObj.deletionPolicy
                            .root.Values.deletionPolicy
                            (.root.Values.global).awsDeletionPolicy
                            "Orphan" }}
{{- end -}}
