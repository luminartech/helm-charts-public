{{/* vim: set filetype=mustache: */}}
{{/*
Render the policy Json from Yaml with support of templating in input.
4 spaces are used for indentation as it's preffered by AWS
Accepts dict:
{
  root: [map] - root context
  value: [dict] - policy
}
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
{{- end -}}
