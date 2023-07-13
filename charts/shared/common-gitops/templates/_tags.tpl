{{/* vim: set filetype=mustache: */}}
{{/*
Generate tags map based on values set on global, resource kind and resource item levels.
There're multiple formats of tags definition so it makes sense to put common logic into one template and re-use it in
each separate template per format below.
For common-gitops chart usage only! Please, use other templates down below.
Billing-* tags are intentionally set to "Unknown" by default to remind user about their existance and importance.
Input dict:
{
  root: [map] - root context
  kind: [string] - resource kind name, e.g. "Policy"
  name: [string] - item id, e.g. "argocd"
  nameOverride: [string] - override name if set
}
Returns dict:
{
  tag_key: tag_value
}
*/}}
{{- define "common-gitops.tags._common" -}}
  {{- $defaults := (dict
    "Name" (include "common-gitops.names.itemFullname" (dict "root" .root "name" .name "override" .nameOverride))
    "Chart" (printf "%s-%s" (include "common-gitops.names.chart" .root) (.root.Chart.Version))
    "Release" (include "common-gitops.names.release" .root)
    "Managed-By" (.root.Release.Service)
    "Billing-Center" "Unknown"
    "Billing-Team" "Unknown"
    "Billing-Org" "Unknown"
  ) -}}
  {{- $kindObj := (get (.root.Values) .kind) -}}
  {{- $item := (get $kindObj.items .name) -}}
  {{- /* Left argument takes precedence over the right one */ -}}
  {{- with merge (($item.spec).tags)
                 (($item.forProvider).tags)
                 ($item.tags)
                 ($kindObj.tags)
                 ((.root.Values.global).tags)
                 ($defaults) }}
    {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $.root) -}}
  {{- end -}}
{{- end -}}
{{/* Build a tags parameter for resource in form of a _list_.
Input dict:
{
  root: [map] - root context
  kind: [string] - resource kind name, e.g. "Policy"
  name: [string] - item id, e.g. "argocd"
}
Sample return:
tags:
  - key: tag_key
    value: tag_value
TODO: Add other common resource tags such as costing, BU, owner...
*/}}
{{- define "common-gitops.tags.list" -}}
  {{- range $key, $value := (include "common-gitops.tags._common" (dict "root" .root "kind" .kind "name" .name "nameOverride" .nameOverride) | fromYaml) }}
- key: "{{ $key }}"
  value: "{{ $value }}"
  {{- end -}}
{{- end -}}

{{/*
Build a tags parameter for resource in form of a _prefixed list_.
Input dict:
{
  root: [map] - root context
  kind: [string] - resource kind name, e.g. "Policy"
  name: [string] - item id, e.g. "argocd"
}
Sample return:
tags:
  - key: tag_key
    value: tag_value

TODO: Add other common resource tags such as costing, BU, owner...
*/}}
{{- define "common-gitops.tags.prefixed_list" -}}
  {{- range $key, $value := include "common-gitops.tags._common" (dict "root" .root "kind" .kind "name" .name "nameOverride" .nameOverride) | fromYaml }}
- tagKey: "{{ $key }}"
  tagValue: "{{ $value }}"
  {{- end -}}
{{- end -}}
{{/*
Build a tags parameter for resource in form of a _dict_.
Input dict:
{
  root: [map] - root context
  kind: [string] - resource kind name, e.g. "Policy"
  name: [string] - item id, e.g. "argocd"
}
Sample return:
tags:
  tag_key: tag_value

TODO: Add other common resource tags such as costing, BU, owner...
*/}}
{{- define "common-gitops.tags.dict" -}}
  {{- include "common-gitops.tags._common" (dict "root" .root "kind" .kind "name" .name "nameOverride" .nameOverride) -}}
{{- end -}}
