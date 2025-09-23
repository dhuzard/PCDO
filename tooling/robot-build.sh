#!/usr/bin/env bash
set -euo pipefail

ROBOT_BIN=${ROBOT_BIN:-robot}

echo "[PCDO] Generating import modules (OBI, IAO)"
mkdir -p imports dist reports

"$ROBOT_BIN" extract \
  --method MIREOT \
  --input http://purl.obolibrary.org/obo/obi.owl \
  --term http://purl.obolibrary.org/obo/OBI_0000066 \
  --term http://purl.obolibrary.org/obo/OBI_0000070 \
  --term http://purl.obolibrary.org/obo/OBI_0000747 \
  --intermediates minimal \
  --output imports/obi_import.owl

"$ROBOT_BIN" extract \
  --method MIREOT \
  --input http://purl.obolibrary.org/obo/iao.owl \
  --term http://purl.obolibrary.org/obo/IAO_0000311 \
  --term http://purl.obolibrary.org/obo/IAO_0000115 \
  --intermediates minimal \
  --output imports/iao_import.owl

echo "[PCDO] Converting ontology to RDF/XML (.owl) and JSON-LD"
"$ROBOT_BIN" convert -I ontology/pcdo.ttl -o dist/pcdo.owl
"$ROBOT_BIN" convert -I ontology/pcdo.ttl -o dist/pcdo.jsonld

echo "[PCDO] Running ROBOT report"
"$ROBOT_BIN" report -I ontology/pcdo.ttl -o reports/robot-report.tsv

echo "Done. Artifacts in dist/, reports/, and imports/."
