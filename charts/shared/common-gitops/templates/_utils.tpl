{{/* vim: set filetype=mustache: */}}
{{/*
Get _lower_ level domain (host) name from URL.

Input string:
  https://F9B61BD5C5DA00880000009F3337505E.gr7.us-west-2.eks.amazonaws.com
or:
  F9B61BD5C5DA00880000009F3337505E.gr7.us-west-2.eks.amazonaws.com
Sample output:
  F9B61BD5C5DA00880000009F3337505E
*/}}
{{- define "common-gitops.utils.urlToHost" -}}
  {{- if contains "://" . -}}
    {{- (splitList "." ((splitList "/" .) | last)) | first -}}
  {{- else -}}
    {{- (splitList "." .) | first -}}
  {{- end -}}
{{- end -}}

{{/*
Make sure that input string meets RFC 1123/1035 length requirements.
See https://kubernetes.io/docs/concepts/overview/working-with-objects/names/#dns-label-names
*/}}
{{- define "common-gitops.utils.validateLength" -}}
  {{- if gt (len .) 63 -}}
    {{- fail (printf "%s: %s" "string must be 63 characters long or less" .) -}}
  {{- else -}}
    {{- . -}}
  {{- end -}}
{{- end -}}

{{/*
Calculate subnet Cidr by given vpcCidr and suffix.
Main goal is to provide end-user the easy way to set the vpcSubnet and get the full list of subnets
generated automatically.

Input dict:
{
  vpcCidr: [strign] - VPC Cidr, e.g. 10.127.16.0/20
  suffix: [string] - suffix, e.g. "16.0/24"
}
Returns string:
  "10.127.16.0/24"
*/}}
{{- define "common-gitops.utils.subnetCidr" -}}
  {{- $mask := splitList "/" .vpcCidr | last | atoi -}}
  {{- $net := splitList "/" .vpcCidr| first | split "." -}}
  {{- if and (ge $mask 24) (le $mask 30) -}}
    {{- printf "%s.%s.%s.%s" $net._0 $net._1 $net._2 .suffix -}}
  {{- else if and (ge $mask 16) (lt $mask 24) -}}
    {{- printf "%s.%s.%s" $net._0 $net._1 .suffix -}}
  {{- else if and (ge $mask 8) (lt $mask 16) -}}
    {{- printf "%s.%s" $net._0 .suffix -}}
  {{- else -}}
    {{- fail "Netmask is expected to be a number >= 8 and <=30" -}}
  {{- end -}}
{{- end -}}

{{/*
Compute the logic of item enabled/disabled state.

Input dict:
{
  root: [map] - root context
  kind: [string] - resource kind name, e.g. "Policy"
  name: [string] - item id, e.g. "argocd"
}
Sample return (always string):
true
*/}}
{{- define "common-gitops.utils.itemEnabled" -}}
  {{- $kindObj := (get (.root.Values) .kind) -}}
  {{- $item := (get $kindObj.items .name) -}}
  {{- hasKey $item "enabled" | ternary
      (eq (include "common-gitops.tplvalues.render" (
        dict "value" ($item.enabled | toString) "context" .root)) "true")
      (ne (include "common-gitops.tplvalues.render" (
        dict "value" ($kindObj.enabled | toString) "context" .root)) "false") }}
{{- end -}}
