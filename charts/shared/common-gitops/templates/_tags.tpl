{{/* vim: set filetype=mustache: */}}
{{/*
There're multiple formats of tags definition so there's a separate template per format below.
*/}}
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
tags:
  - key: "Name"
    value: "{{ include "common-gitops.names.itemFullname" (dict "root" .root "name" .name "override" .nameOverride) }}"
  - key: "Release"
    value: "{{ include "common-gitops.names.release" .root }}"
  - key: "Chart"
    value: "{{ include "common-gitops.names.chart" .root }}-{{ .root.Chart.Version }}"
  - key: "Managed-By"
    value: "{{ .root.Release.Service }}"
  {{- $kindObj := (get (.root.Values) .kind) -}}
  {{- $item := (get $kindObj.items .name) -}}
  {{- /* Left argument takes precedence over the right one */ -}}
  {{- range $key, $value := merge (($item.spec).tags)
                                  (($item.forProvider).tags)
                                  ($item.tags)
                                  ($kindObj.tags)
                                  ((.root.Values.global).tags) }}
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
tags:
  - tagKey: "Name"
    tagValue: "{{ include "common-gitops.names.itemFullname" (dict "root" .root "name" .name "override" .nameOverride) }}"
  - tagKey: "Release"
    tagValue: "{{ include "common-gitops.names.release" .root }}"
  - tagKey: "Chart"
    tagValue: "{{ include "common-gitops.names.chart" .root }}-{{ .root.Chart.Version }}"
  - tagKey: "Managed-By"
    tagValue: "{{ .root.Release.Service }}"
  {{- $kindObj := (get (.root.Values) .kind) -}}
  {{- $item := (get $kindObj.items .name) -}}
  {{- /* Left argument takes precedence over the right one */ -}}
  {{- range $key, $value := merge (($item.spec).tags)
                                  (($item.forProvider).tags)
                                  ($item.tags)
                                  ($kindObj.tags)
                                  ((.root.Values.global).tags) }}
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
tags:
  Name: "{{ include "common-gitops.names.itemFullname" (dict "root" .root "name" .name "override" .nameOverride) }}"
  Chart: "{{ include "common-gitops.names.chart" .root }}-{{ .root.Chart.Version }}"
  Release: "{{ include "common-gitops.names.release" .root }}"
  Managed-By: "{{ .root.Release.Service }}"
  {{- $kindObj := (index (.root.Values) .kind) -}}
  {{- $item := (index $kindObj.items .name) -}}
  {{- /* Left argument takes precedence over the right one */ -}}
  {{- with merge (($item.spec).tags)
                 (($item.forProvider).tags)
                 ($item.tags)
                 ($kindObj.tags)
                 ((.root.Values.global).tags) }}
    {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $.root) | nindent 2 -}}
  {{- end -}}
{{- end -}}
