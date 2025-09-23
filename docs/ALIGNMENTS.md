# Standards Alignment

- DataCite: `datacite:identifierValue`, `datacite:resourceTypeGeneral`, optional `datacite:hasIdentifier` pattern.
- DCAT/Schema.org: `pcdo:Dataset ⊑ dcat:Dataset, schema:Dataset` for discoverability.
- PROV-O: `pcdo:Dataset ⊑ prov:Entity`, `pcdo:Study ⊑ prov:Activity` for provenance hooks.
- OBI/IAO: study, assay, sample, document anchors.
- SOSA: observations and observable properties for outcomes.
- OWL-Time: reserved for future time interval modeling.
- QUDT: units for doses; full quantity pattern can be added post-0.1.

See `ontology/pcdo-align.ttl` for machine-readable triples.

