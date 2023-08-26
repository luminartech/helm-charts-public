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
  serviceAccountName: {{ include "common-gitops.names.itemFullname" (dict "root" $root "name" $name "override" .serviceAccountName) }}
      {{- with .automountServiceAccountToken }}
  automountServiceAccountToken: {{ include "common-gitops.tplvalues.render" (dict "value" . "context" $root) }}
      {{- end -}}
      {{- with .hostIPC }}
  hostIPC: {{ . }}
      {{- end -}}
      {{- with .hostNetwork }}
  hostNetwork: {{ . }}
      {{- end -}}
      {{- with .hostPID }}
  hostPID: {{ . }}
      {{- end -}}
      {{- with .hostname }}
  hostname: {{ include "common-gitops.tplvalues.render" (dict "value" . "context" $root) }}
      {{- end -}}
      {{- with .nodeName }}
  nodeName: {{ include "common-gitops.tplvalues.render" (dict "value" . "context" $root) }}
      {{- end -}}
      {{- with .preemptionPolicy }}
  preemptionPolicy: {{ include "common-gitops.tplvalues.render" (dict "value" . "context" $root) }}
      {{- end -}}
      {{- with .priority }}
  priority: {{ . }}
      {{- end -}}
      {{- with .priorityClassName }}
  priorityClassName: {{ include "common-gitops.tplvalues.render" (dict "value" . "context" $root) }}
      {{- end -}}
      {{- with .runtimeClassName }}
  runtimeClassName: {{ include "common-gitops.tplvalues.render" (dict "value" . "context" $root) }}
      {{- end -}}
      {{- with .schedulerName }}
  schedulerName: {{ include "common-gitops.tplvalues.render" (dict "value" . "context" $root) }}
      {{- end -}}
      {{- with .setHostnameAsFQDN }}
  setHostnameAsFQDN: {{ . }}
      {{- end -}}
      {{- with .shareProcessNamespace }}
  shareProcessNamespace: {{ . }}
      {{- end -}}
      {{- with .subdomain }}
  subdomain: {{ include "common-gitops.tplvalues.render" (dict "value" . "context" $root) }}
      {{- end -}}
      {{- with .affinity }}
  affinity:
        {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $root) | nindent 4 }}
      {{- end -}}
      {{- with .dnsConfig }}
  dnsConfig:
        {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $root) | nindent 4 }}
      {{- end -}}
      {{- with .enableServiceLinks }}
  enableServiceLinks: {{ . }}
      {{- end -}}
      {{- with .ephemeralContainers }}
  ephemeralContainers:
        {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $root) | nindent 4 }}
      {{- end -}}
      {{- with .hostAliases }}
  hostAliases:
        {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $root) | nindent 4 }}
      {{- end -}}
      {{- with ($root.Values.global).imagePullSecrets }}
  imagePullSecrets:
        {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $root) | nindent 2 }}
      {{- end -}}
      {{- with .ephemeralContainers }}
  ephemeralContainers:
        {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $root) | nindent 4 }}
      {{- end -}}
      {{- with .nodeSelector }}
  nodeSelector:
        {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $root) | nindent 4 }}
      {{- end -}}
      {{- with .overhead }}
  overhead:
        {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $root) | nindent 4 }}
      {{- end -}}
      {{- with .readinessGates }}
  readinessGates:
        {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $root) | nindent 4 }}
      {{- end -}}
      {{- with .tolerations }}
  tolerations:
        {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $root) | nindent 4 }}
      {{- end -}}
      {{- with .topologySpreadConstraints }}
  topologySpreadConstraints:
        {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $root) | nindent 4 }}
      {{- end -}}
      {{- with .volumes }}
  volumes:
        {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $root) | nindent 4 }}
      {{- end -}}
      {{- with .restartPolicy }}
  restartPolicy: {{ include "common-gitops.tplvalues.render" (dict "value" . "context" $root) }}
      {{- else }}
  restartPolicy: Never
      {{- end -}}
      {{- with .dnsPolicy }}
  dnsPolicy: {{ include "common-gitops.tplvalues.render" (dict "value" . "context" $root) }}
      {{- else }}
  dnsPolicy: ClusterFirst
      {{- end -}}
      {{- with .schedulerName }}
  schedulerName: {{ include "common-gitops.tplvalues.render" (dict "value" . "context" $root) }}
      {{- end -}}
      {{- with .securityContext }}
  securityContext:
        {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $root) | nindent 4 }}
      {{- end -}}
      {{- with .activeDeadlineSeconds }}
  activeDeadlineSeconds: {{ . }}
      {{- end -}}
      {{- with .terminationGracePeriodSeconds }}
  terminationGracePeriodSeconds: {{ . }}
      {{- else }}
  terminationGracePeriodSeconds: 30
      {{- end -}}
      {{- with .initContainers }}
  initContainers:
        {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $root) | nindent 4 }}
      {{- end -}}
      {{- with .containers }}
  containers:
        {{- include "common-gitops.tplvalues.render" (dict "value" . "context" $root) | nindent 4 }}
      {{- end -}}
    {{- end -}}
  {{- end -}}
{{- end }}
