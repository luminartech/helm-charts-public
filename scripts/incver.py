#!/usr/bin/env python3
# Increments the prerelease version by one in "version" field of a yaml file
# Input: one positional argument - path to yaml file with "version" key in it (Chart.yaml)

import sys
import os
import semver
from ruamel.yaml import YAML

filename = sys.argv[1]
yaml = YAML()
with open(filename, "r") as f:
    data = yaml.load(f)
version = semver.parse_version_info(data["version"])
if version.prerelease:
    version = version.replace(prerelease=int(version.prerelease)+1)
else:
    version = version.replace(prerelease=0)
data["version"] = str(version)
yaml.indent(mapping=2, sequence=4, offset=2)
with open(f"{filename}.bak", "w") as f:
    yaml.dump(data, f)
os.rename(f"{filename}.bak", filename)
