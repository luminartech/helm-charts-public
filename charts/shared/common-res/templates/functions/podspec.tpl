{{- define "common-res.podSpec" -}}
  {{- $kindObj := (get .root.Values .kind) -}}
  {{- $kind := .kind -}}
  {{- $root := .root -}}
  {{- $name := .name -}}
  {{- $item := (get $kindObj.items .name) -}}
  {{- with mergeOverwrite ((.root.Values.global).podSpec)
                           ($kindObj.podSpec)
                           ($item.podSpec) }}
metadata:
    {{- with .name }}
  name: {{ include "common-gitops.tplvalues.render" (dict "value" . "context" $root) }}
    {{- end -}}
    {{- include "common-gitops.labels" (dict "root" $root "name" $name "kind" $kind) | trim | nindent 2 }}
    {{- include "common-gitops.annotations" (dict "root" $root "name" $name "kind" $kind) | trim | nindent 2 }}
    {{- with .spec }}
spec:
      {{- include "common-gitops.tplvalues.render" (dict
        "value" (omit . "initContainers" "containers")
        "context" $root
        "trimEmpty" "true") | nindent 2 -}}
      {{ with .initContainers }}
  initContainers:
        {{- if kindIs "slice" . -}}
          {{/* Standard list-like syntax */}}
          {{ include "common-gitops.tplvalues.render" (dict "value" . "context" $root) | nindent 4 -}}
        {{- else if kindIs "map" . -}}
          {{/* Dict-like syntax */}}
          {{- $containers := . -}}
          {{ range $name := keys $containers | sortAlpha -}}
            {{ $container := get $containers $name }}
  - name: {{ $name -}}
            {{ include "common-gitops.tplvalues.render" (dict "value" $container "context" $root) | nindent 4 -}}
          {{ end }}
        {{- else }}
          {{- fail "value for initContainers is not list nor dictionary" }}
        {{ end }}
      {{ end }}
      {{ with .containers }}
  containers:
        {{- if kindIs "slice" . }}
          {{/* Standard list-like syntax */}}
          {{ include "common-gitops.tplvalues.render" (dict "value" . "context" $root) | nindent 4 -}}
        {{- else if kindIs "map" . -}}
          {{/* Dict-like syntax */}}
          {{- $containers := . -}}
          {{- $names := keys $containers | sortAlpha -}}
          {{ range $name := $names -}}
            {{ $container := get $containers $name }}
  - name: {{ $name -}}
            {{ include "common-gitops.tplvalues.render" (dict "value" $container "context" $root) | nindent 4 -}}
          {{ end }}
        {{- else }}
          {{- fail "value for containers is not list nor dictionary" }}
        {{ end }}
      {{ end }}
    {{- end -}}
  {{- end -}}
{{- end -}}
