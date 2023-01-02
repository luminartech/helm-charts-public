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
