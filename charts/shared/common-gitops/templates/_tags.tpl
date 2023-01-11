{{/* vim: set filetype=mustache: */}}
{{/* Build a tags _list_ for a resource:
Input dict:
{
  root: [map] .
  kind: [map] "Policy"
  name: [string] item1
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
Build a tags _prefixed list_ for a resource:
Input dict:
{
  root: [map] .
  kind: [map] "Policy"
  name: [string] item1
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
Build a tags _dict_ for a resource:
Input dict:
{
  root: [map] .
  kind: [map] "Policy"
  name: [string] item1
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
  {{- with merge (($item.spec).tags)
                 (($item.forProvider).tags)
                 ($item.tags)
                 ($kindObj.tags)
                 ((.root.Values.global).tags) }}
    {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $.root) | nindent 2 -}}
  {{- end -}}
{{- end -}}
