#!/usr/bin/env python3
"""
Builds Grafana dashboards templates from grafana-dashboards/*.json files for this chart.

Inspired by https://github.com/prometheus-community/helm-charts/blob/main/charts/kube-prometheus-stack/hack/sync_grafana_dashboards.py,
see https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack/hack
for more details on original approach.
"""
import json
import re
import textwrap
from pathlib import Path
import yaml
from yaml.representer import SafeRepresenter


# https://stackoverflow.com/a/20863889/961092
class LiteralStr(str):
    """Represents Literal string for pyyaml."""

    pass


def change_style(style, representer):
    """Returns yaml representer function."""

    def new_representer(dumper, data):
        """Representer function to be used in yaml module."""
        scalar = representer(dumper, data)
        scalar.style = style
        return scalar

    return new_representer


_JSON_DIR = Path(__file__).parent / "grafana-dashboards"
_JSON_PATTERN = "**/*.json"
_DESTINATION_FOLDER = Path(__file__).parent / "../templates/grafana/dashboards-1.14"
_MULTICLUSTER_KEY = ".Values.kube-prometheus-stack.grafana.sidecar.dashboards.multicluster.global.enabled"

# Additional conditions map
_CONDITION_MAP = {
    "argocd-basic": ".Values.commonGrafanaDashboards.argocdBasicEnabled",
    "cert-manager": ".Values.commonGrafanaDashboards.certManagerEnabled",
    "crossplane": ".Values.commonGrafanaDashboards.crossplaneEnabled",
    "external-dns": ".Values.commonGrafanaDashboards.externalDnsEnabled",
    "karpenter-capacity": ".Values.commonGrafanaDashboards.karpenterCapacityEnabled",
    "karpenter-performance": ".Values.commonGrafanaDashboards.karpenterPerformanceEnabled",
    "loki": ".Values.commonGrafanaDashboards.lokiEnabled",
    "nginx-ingress": ".Values.commonGrafanaDashboards.nginxIngressEnabled",
    "nvidia-dcgm": ".Values.commonGrafanaDashboards.nvidiaDcgmEnabled",
    "trivy-vulnerabilities": ".Values.commonGrafanaDashboards.trivyVulnerabilitiesEnabled",
}

# standard _TEMPLATE_HEADER
_TEMPLATE_HEADER = """{{- /*
Generated from '%(name)s'
Do not change in-place! In order to change this file look into %(script)s
*/ -}}
{{- if %(condition)s }}
apiVersion: v1
kind: ConfigMap
metadata:
  namespace: {{ .Release.Namespace }}
  name: {{ print "grafana-dashboard-%(name)s" | trunc 63 | trimSuffix "-" }}
  labels:
    grafana_dashboard: "1"
    app: {{ .Values.global.deploymentName }}-grafana
data:
"""


def init_yaml_styles():
    """Inits style for yaml."""
    represent_literal_str = change_style("|", SafeRepresenter.represent_str)
    yaml.add_representer(LiteralStr, represent_literal_str)


def escape(json_string):
    """Escaping values with {{ }} references."""
    return (
        json_string.replace("{{", "{{`{{")
        .replace("}}", "}}`}}")
        .replace("{{`{{", "{{`{{`}}")
        .replace("}}`}}", "{{`}}`}}")
    )


def unescape(json_string):
    r"""Unescaping values with \{\{ \}\} references."""
    return json_string.replace(r"\{\{", "{{").replace(r"\}\}", "}}")


def yaml_str_repr(struct, indent=2):
    """Represent yaml as a string."""
    text = yaml.dump(
        struct,
        width=1000,  # to disable line wrapping
        default_flow_style=False,  # to disable multiple items on single line
    )
    text = escape(text)  # escape {{ and }} for helm
    text = unescape(text)  # unescape \{\{ and \}\} for templating
    text = textwrap.indent(text, " " * indent)
    return text


def patch_dashboards_json(content):
    """Patching json content."""
    try:
        content_struct = json.loads(content)

        # multicluster
        overwrite_list = []
        for variable in content_struct.get("templating", {}).get("list", {}):
            if variable["name"] == "cluster":
                variable["hide"] = ":multicluster:"
            overwrite_list.append(variable)
        content_struct["templating"]["list"] = overwrite_list

        # fix drilldown links.
        # See https://github.com/kubernetes-monitoring/kubernetes-mixin/issues/659
        for row in content_struct.get("rows", {}):
            for panel in row.get("panels", {}):
                for style in panel.get("styles", []):
                    if "linkUrl" in style and style["linkUrl"].startswith("./d"):
                        style["linkUrl"] = style["linkUrl"].replace("./d", "/d")

        content_array = []
        original_content_lines = content.split("\n")
        for i, line in enumerate(json.dumps(content_struct, indent=4).split("\n")):
            if (" []" not in line and " {}" not in line) or line == original_content_lines[i]:
                content_array.append(line)
                continue

            append = ""
            if line.endswith(","):
                line = line[:-1]
                append = ","

            if line.endswith("{}") or line.endswith("[]"):
                content_array.append(line[:-1])
                content_array.append("")
                content_array.append(" " * (len(line) - len(line.lstrip())) + line[-1] + append)

        content = "\n".join(content_array)

        # multicluster = content.find(":multicluster:")
        # if multicluster != -1:
        #     content = "".join(
        #         (
        #             content[: multicluster - 1],
        #             r"\{\{ if %s \}\}0\{\{ else \}\}2\{\{ end \}\}" % _MULTICLUSTER_KEY,
        #             content[multicluster + 15 :],
        #         )
        #     )
    except (ValueError, KeyError):
        pass

    return content


def patch_json_timezone_as_variable(content):
    """Patching timezone value in text representation of json."""
    # content is no more in json format, so we have to replace using regex
    return re.sub(
        r'"timezone"\s*:\s*"(?:\\.|[^\"])*"',
        # r'"timezone": "\{\{ .Values.kube-prometheus-stack.grafana.defaultDashboardsTimezone \}\}"',
        r'"timezone": "utc"',
        content,
        flags=re.IGNORECASE,
    )


def write_group_to_file(resource_name, content, destination):
    """Writes template from content to destination folder."""
    # initialize _TEMPLATE_HEADER
    lines = _TEMPLATE_HEADER % {
        "name": resource_name,
        "condition": _CONDITION_MAP.get(resource_name, ""),
        "script": Path(__file__).name,
    }

    content = patch_dashboards_json(content)
    content = patch_json_timezone_as_variable(content)

    filename_struct = {resource_name + ".json": (LiteralStr(content))}
    # rules themselves
    lines += yaml_str_repr(filename_struct)

    # footer
    lines += "{{- end }}\n"

    filename = resource_name + ".yaml"
    new_filename = "%s/%s" % (destination, filename)

    # make sure directories to store the file exist
    Path(destination).mkdir(exist_ok=True)

    # recreate the file
    output_file = Path(new_filename)
    output_file.write_text(lines)

    print("Generated", new_filename)


def main():
    """Main function to convert .json dashboard into heml template."""
    init_yaml_styles()
    # read the rules, create a new template file per group
    print("Generating rules from", _JSON_DIR)
    dashboards_dir = Path(_JSON_DIR)
    for json_path in dashboards_dir.glob(_JSON_PATTERN):
        if not json_path.is_file():
            continue
        resource_name = str(json_path.name).replace(".json", "")
        if resource_name not in _CONDITION_MAP:
            print(resource_name, "is missing in _CONDITION_MAP, please update", Path(__file__).name)
            continue
        json_content = json_path.read_text()
        write_group_to_file(resource_name, json_content, _DESTINATION_FOLDER)
    print("Finished")


if __name__ == "__main__":
    main()
