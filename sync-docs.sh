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

echo -e "${BLUE}Cloning docs repository...${NC}"

git clone --depth 1 --branch rhacs-docs https://github.com/openshift/openshift-docs.git /tmp/openshift-docs

rm -rf /tmp/openshift-docs/.git

echo -e "${BLUE}Deleting symlinks...${NC}"

find /tmp/openshift-docs -type l -delete

echo -e "${BLUE}Updating files...${NC}"

cp -rf /tmp/openshift-docs/modules/* ./docs/modules/ROOT/partials/

cp -rf /tmp/openshift-docs/images/* ./docs/modules/ROOT/images/

cp -rf /tmp/openshift-docs/files/* ./docs/modules/_files/

cp -rf /tmp/openshift-docs/welcome/* ./docs/modules/ROOT/pages/

cp -rf /tmp/openshift-docs/architecture/* ./docs/modules/architecture/pages/

cp -rf /tmp/openshift-docs/backup_and_restore/* ./docs/modules/backup_and_restore/pages/

cp -rf /tmp/openshift-docs/cli/* ./docs/modules/cli/pages/

cp -rf /tmp/openshift-docs/configuration/* ./docs/modules/configuration/pages/

cp -rf /tmp/openshift-docs/installing/* ./docs/modules/installing/pages/

cp -rf /tmp/openshift-docs/integration/* ./docs/modules/integration/pages/

cp -rf /tmp/openshift-docs/operating/* ./docs/modules/operating/pages/

cp -rf /tmp/openshift-docs/release_notes/* ./docs/modules/release_notes/pages/

cp -rf /tmp/openshift-docs/support/* ./docs/modules/support/pages/

cp -rf /tmp/openshift-docs/upgrading/* ./docs/modules/upgrading/pages/

echo -e "${BLUE}Removing cloned repository...${NC}"

rm -rf /tmp/openshift-docs

echo -e "${BLUE}Updating include paths ...${NC}"

grep -rl --include=\*.adoc include::modules\/ . | xargs sed -i "" 's+include::modules/+include::ROOT:partial$+g'

echo -e "${BLUE}Removing TOC from pages ...${NC}"

grep -rl --include=\*.adoc 'toc::\[\]' . | xargs sed -i "" 's+toc::\[\]+:source-highlighter: highlight.js+g'

echo -e "${BLUE}Updating xrefs ...${NC}"
# TBD: Use regex to convert the xrefs to the Antora format
# Does not handle links in the format ../filename.adoc

grep -rl --include=\*.adoc 'xref:../../' . | xargs sed -i "" 's+xref:../../+xref:../+g'

grep -rl --include=\*.adoc xref:../architecture/ . | xargs sed -i "" 's+xref:../architecture/+xref:architecture:+g'

grep -rl --include=\*.adoc xref:../backup_and_restore/ . | xargs sed -i "" 's+xref:../backup_and_restore/+xref:backup_and_restore:+g'

grep -rl --include=\*.adoc xref:../cli/ . | xargs sed -i "" 's+xref:../cli/+xref:cli:+g'

grep -rl --include=\*.adoc xref:../configuration/ . | xargs sed -i "" 's+xref:../configuration/+xref:configuration:+g'

grep -rl --include=\*.adoc xref:../installing/ . | xargs sed -i "" 's+xref:../installing/+xref:installing:+g'

grep -rl --include=\*.adoc xref:../integration/ . | xargs sed -i "" 's+xref:../integration/+xref:integration:+g'

grep -rl --include=\*.adoc xref:../operating/ . | xargs sed -i "" 's+xref:../operating/+xref:operating:+g'

grep -rl --include=\*.adoc xref:../release_notes/ . | xargs sed -i "" 's+xref:../release_notes/+xref:release_notes:+g'

grep -rl --include=\*.adoc xref:../support/ . | xargs sed -i "" 's+xref:../support/+xref:support:+g'

grep -rl --include=\*.adoc xref:../upgrading/ . | xargs sed -i "" 's+xref:../upgrading/+xref:upgrading:+g'

echo -e "${BLUE}Updating image paths ...${NC}"

grep -rl --include=\*.adoc image:: . | xargs sed -i "" 's+image::+image::ROOT:+g'

echo -e "${BLUE}Adding product name and version ...${NC}"

PROD_VERSION=$(grep ':rhacs-version:' docs/modules/ROOT/partials/common-attributes.adoc | cut -c 17-20)

sed -i '' "s/version:.*/version: $PROD_VERSION/" docs/antora.yml

echo -e "${GREEN}Done!${NC}"
