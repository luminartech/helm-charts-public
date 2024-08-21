{{/* vim: set filetype=mustache: */}}
{{/*
Render the managementPolicies value for crossplane resource:
Accepts dict:
{
  root: [map] - root context
  kind: [string] - resource kind name, e.g. "Policy"
  name: [string] - item id, e.g. "argocd"
}
Sample return:
managementPolicies: ["*"]
*/}}
{{- define "common-gitops.crossplane.managementPolicies" -}}
  {{- $kindObj := (index .root.Values .kind) -}}
  {{- $item := (index $kindObj.items .name) -}}
  {{- /* Take the first non-empty argument */ -}}
managementPolicies: {{ include "common-gitops.tplvalues.render" (dict
                     "value" (coalesce $item.managementPolicies
                        $kindObj.managementPolicies
                        .root.Values.managementPolicies
                        (.root.Values.global).awsManagementPolicies
                        (list "*"))
                     "context" .root) }}
{{- end -}}
