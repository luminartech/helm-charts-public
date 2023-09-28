{{/* vim: set filetype=mustache: */}}
{{/*
Render the policy Json from Yaml with support of templating in input.
4 spaces are used for indentation as it's preffered by AWS
Accepts dict:
{
  root: [map] - root context
  value: [string or dict] - policy
}
Important note. Policy can be provided in 3 mutually exclusive formats:
- raw Json (string)
- yaml that is exact representation of Json (Statement value is a list)
- yaml in which Statement value is a dict with keys playing a role of statement Sids
See values-test.yaml for examples.
Sample return:
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": [
                "iam:GetAccountSummary",
                "iam:ListAccountAliases",
                "account:ListRegions"
            ],
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "accountRead"
        },
        {
            "Action": "route53:ListHostedZonesByName",
            "Effect": "Allow",
            "Resource": "*",
            "Sid": "route53ListHostedZones"
        }
    ]
}
*/}}
{{- define "common-gitops.crossplane.awsPolicy" -}}
  {{- if .value -}}
    {{- if kindIs "string" .value -}}
      {{ include "common-gitops.tplvalues.render" (dict "value" .value "context" .root) }}
    {{- else if kindIs "map" .value -}}
      {{- if kindIs "slice" .value.Statement -}}
        {{ include "common-gitops.tplvalues.render" (dict "value" .value "context" .root) |
          fromYaml |
          mustToPrettyJson |
          replace "  " "    " -}}
      {{- else if kindIs "map" .value.Statement -}}
{
    "Version": "{{ .value.Version | default "2012-10-17" }}",
    "Statement": [
        {{- $Statement := .value.Statement -}}
        {{- /* List allows to find out inside the loop if the item is last and comma is not needed */ -}}
        {{- $Sids := keys $Statement | sortAlpha -}}
        {{ range $sid := $Sids -}}
          {{ $stmt := get $Statement $sid -}}
          {{ $_ := set $stmt "Sid" $sid -}}
          {{ include "common-gitops.tplvalues.render" (dict "value" $stmt "context" $.root) |
              fromYaml |
              mustToPrettyJson |
              replace "  " "    " |
              nindent 8 -}}
          {{ if ne (last $Sids) $sid }},{{ end -}}
        {{ end }}
    ]
}
      {{- else -}}
        {{- fail (print "Unsupported Statement type of policy document: " (kindOf .value.Statement)) -}}
      {{- end -}}
    {{- else -}}
      {{- fail (print "Unsupported type of policy document: " (kindOf .value)) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}
