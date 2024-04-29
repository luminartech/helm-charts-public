{{/* vim: set filetype=mustache: */}}
{{/* Renders a value for initContainers, containers, and ephemeralContainers.
Input dict:
{
    value: [map] - template
    root: [map] - root context
}
*/}}
{{- define "common-res.containersSpec" -}}
  {{- $root := .root -}}
  {{- $value := .value -}}
  {{/* Render list "as-is", while dictionary needs to be converted to list */}}
  {{- if kindIs "slice" $value -}}
    {{- include "common-gitops.tplvalues.render" (dict "value" $value "context" $root) | nindent 2 -}}
  {{- else if kindIs "map" $value -}}
    {{- $containers := $value -}}
    {{- range $name := keys $containers | sortAlpha -}}
      {{- $container := get $containers $name -}}
- name: {{ $name }}
      {{- include "common-gitops.tplvalues.render" (dict "value" $container "context" $root) | nindent 2 -}}
    {{- end -}}
  {{- else -}}
    {{- fail "value for initContainers is not list nor dictionary" -}}
  {{- end -}}
{{- end -}}

{{/* vim: set filetype=mustache: */}}
{{/* Renders a value for podSpec.
Accepts dict:
{
  root: [map] - root context
  kind: [string] - resource kind name, e.g. "Deployment"
  name: [string] - item id, e.g. "argocd"
}
*/}}
{{- define "common-res.podSpec" -}}
  {{- $kindObj := (get .root.Values .kind) -}}
  {{- $kind := .kind -}}
  {{- $root := .root -}}
  {{- $name := .name -}}
  {{- $item := (get $kindObj.items .name) -}}
  {{- with mergeOverwrite ((.root.Values.global).podSpec)
                           ($kindObj.podSpec)
                           ($item.podSpec) -}}
metadata:
    {{- with .name -}}
  name: {{ include "common-gitops.tplvalues.render" (dict "value" . "context" $root) }}
    {{- end }}
    {{- include "common-gitops.labels" (dict "root" $root "name" $name "kind" $kind) | trim | nindent 2 }}
    {{- include "common-gitops.annotations" (dict "root" $root "name" $name "kind" $kind) | trim | nindent 2 }}
    {{- with .spec }}
spec:
      {{- include "common-gitops.tplvalues.render" (dict
        "value" (omit .
          "containers"
          "ephemeralContainers"
          "initContainers"
          "serviceAccountName"
          "dnsPolicy"
          "terminationGracePeriodSeconds"
          "image"
        )
        "context" $root
        "trimEmpty" "true") | nindent 2 }}
  serviceAccountName: {{ include "common-gitops.names.itemFullname" (dict "root" $root "name" $name "override" .serviceAccountName) }}
      {{- with .initContainers }}
  initContainers:
        {{- include "common-res.containersSpec" (dict "value" . "root" $root) | nindent 2 }}
      {{- end }}
      {{- with .ephemeralContainers }}
  ephemeralContainers:
        {{- include "common-res.containersSpec" (dict "value" . "root" $root) | nindent 2 }}
      {{- end }}
      {{- with .containers }}
  containers:
        {{- include "common-res.containersSpec" (dict "value" . "root" $root) | nindent 2 }}
      {{- end }}
  dnsPolicy: {{ include "common-gitops.tplvalues.render" (dict "value" .dnsPolicy "context" $root "trimEmpty" true) | default "ClusterFirst" }}
  terminationGracePeriodSeconds: {{ include "common-gitops.tplvalues.render" (dict "value" .terminationGracePeriodSeconds "context" $root "trimEmpty" true) | default 30 }}
  restartPolicy: {{ include "common-gitops.tplvalues.render" (dict "value" .restartPolicy "context" $root "trimEmpty" true) | default "Always" }}
    {{- end -}}
  {{- end -}}
{{- end -}}
