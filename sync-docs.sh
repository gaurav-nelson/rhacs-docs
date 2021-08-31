#!/usr/bin/env bash
#
# This script:
# 1. Syncs the docs from the `openshift/openshift-docs` repository `rhacs-docs` branch
# 2. Updates the include path for modules
# 3. Updates the xrefs (Antora specific format)
# 4. Updates the image paths
#

set -eu

NC='\033[0m' # No Color
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'

echo -e "${BLUE}Syncing docs ...${NC}"

vendir sync

echo -e "${BLUE}Updating include paths ...${NC}"

sed -i 's/include::modules\//include::ROOT:partial$/g' *
# sed -i '.bak' 's/foo/bar/g' * for MacOS

