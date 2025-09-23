# Preclinical DataCite Ontology (PCDO)

[![Validate Ontology](https://github.com/dhuzard/datacite-PreclinDOI/actions/workflows/validate.yml/badge.svg)](https://github.com/dhuzard/datacite-PreclinDOI/actions/workflows/validate.yml)
[![ROBOT Build](https://github.com/dhuzard/datacite-PreclinDOI/actions/workflows/robot.yml/badge.svg)](https://github.com/dhuzard/datacite-PreclinDOI/actions/workflows/robot.yml)

A minimal, reusable ontology for describing preclinical studies and their DOI‑minted datasets. PCDO models just enough study semantics (study, cohorts, subjects, interventions, assays, outcomes) to validate DataCite‑ready metadata, enable practical queries, and integrate with applications via JSON‑LD. Constraints are enforced with SHACL; the ontology aligns with established web and biomedical standards.

- Base ontology IRI: https://w3id.org/preclindo/ontology/pcdo
- Version IRI: https://w3id.org/preclindo/ontology/pcdo/0.1.0
- Prefix: `pcdo`
- License: CC BY 4.0

## Why PCDO?
- Interoperable: Aligns with DCAT/Schema.org (datasets), PROV (provenance), OBI/IAO (study/assay/documents), SOSA (observations), OWL‑Time (temporal), QUDT (units), and OBO (NCBITaxon, CHEBI, PATO).
- DataCite‑ready: SHACL shapes check practical DataCite minima (DOI, title, creators, publisher, year, license, resourceTypeGeneral) plus preclinical specifics.
- Developer‑friendly: JSON‑LD context, minimal example, edge cases, and SPARQL queries included. Simple PowerShell/Python validation and CI.
- Lean and extensible: TBox stays small; real‑world constraints live in SHACL; upgrade path to richer units and temporal modeling when needed.

## Scope
- Dataset‑level (what you publish and cite) plus essential in vivo study semantics needed for search, QA, and reuse.
- Typical subjects: animal models (e.g., mouse, rat). Optional samples/specimens.
- Interventions: drugs/biologics (CHEBI), procedures; simple dose/route/schedule.
- Outcomes: assays, observed properties, observations/results.

Out of scope for 0.1: detailed protocol steps, comprehensive instrumentation provenance, full measurement collections, and full QUDT quantity patterns.

## Repository Layout
- Ontology core: `ontology/pcdo.ttl`
- Standards alignment: `ontology/pcdo-align.ttl`
- Ontology metadata/imports: `ontology/pcdo-metadata.ttl`
- JSON‑LD context: `ontology/context.jsonld`
- SHACL shapes: `shapes/pcdo-shapes.ttl`
- Examples (ABox): `examples/abox-minimal.ttl`, `examples/abox-edge-cases.ttl`
- SPARQL queries: `queries/`
- Validation script/CI: `tooling/validate.ps1`, `tooling/validate.py`, `.github/workflows/validate.yml`
- Docs: `docs/MODEL.md`, `docs/ALIGNMENTS.md`, `docs/CHANGELOG.md`

## Namespaces and IRIs
- Prefixes: `pcdo, dcterms, datacite, schema, prov, time, sosa, qudt, unit, obi, iao, dcat, obo`
- OBO dependencies: `NCBITaxon` (species), `CHEBI` (agents), `PATO` (sex)

## Core Model (selected)
- Classes
  - `pcdo:Dataset` ⊑ `dcat:Dataset`, `schema:Dataset` — the DOI‑minted dataset deliverable.
  - `pcdo:Study` ⊑ `obo:OBI_0000066` — investigation with cohorts, interventions, assays, outcomes.
  - `pcdo:Cohort` — subjects grouped by shared characteristics.
  - `pcdo:Subject` ⊑ `obo:OBI_0100026` — animal subject; link to `NCBITaxon` species.
  - `pcdo:Intervention` ⊑ `obo:OBI_0000011` — drug/procedure; agent via `CHEBI` when chemical.
  - `pcdo:Assay` ⊑ `obo:OBI_0000070` — method used to measure outcomes.
  - `pcdo:OutcomeMeasure` ⊑ `sosa:ObservableProperty` — the measured property.
  - `pcdo:Observation` ⊑ `sosa:Observation` — an actual measurement (time‑stamped).
  - `pcdo:Sample` ⊑ `obo:OBI_0000747` — optional specimens.
  - `pcdo:EthicsApproval` ⊑ `obo:IAO_0000311` — ethics document or identifier.
- Object properties (high‑level)
  - Dataset: `pcdo:describesStudy`, `pcdo:hasEthicsApproval`.
  - Study: `pcdo:hasCohort`, `pcdo:hasAssay`, `pcdo:hasOutcomeMeasure`.
  - Cohort/Subject: `pcdo:hasSubject`, `pcdo:hasSpecies`, `pcdo:hasSex`, `pcdo:hasStrain`.
  - Intervention: `pcdo:appliesToCohort`, `pcdo:hasAgent`, `pcdo:hasDoseUnit`, `pcdo:hasRoute`, `pcdo:hasSchedule`.
  - Assay/Obs: `pcdo:observes`, plus `sosa:observedProperty`, `sosa:hasFeatureOfInterest`.
- Datatype properties (pragmatic minimum)
  - Subject: `pcdo:ageInDays` (xsd:integer), `pcdo:bodyWeightGrams` (xsd:decimal).
  - Intervention: `pcdo:doseValue` (xsd:decimal), `pcdo:routeLabel`, `pcdo:scheduleLabel`.
  - Study design: `pcdo:isRandomized` (xsd:boolean), `pcdo:isBlinded` (xsd:boolean), `pcdo:sampleSize` (xsd:integer).

See `ontology/pcdo.ttl` for the authoritative TBox.

## Standards Alignment
- DataCite: model DOIs via `datacite:identifierValue` and validate completeness in SHACL.
- DCAT/Schema.org: subclassing enables discovery in catalog/search systems.
- PROV‑O: `pcdo:Dataset` as `prov:Entity`; `pcdo:Study` as `prov:Activity` (hooks for pipelines).
- OBI/IAO: anchor study/assay/document semantics to OBO.
- SOSA/SSN: reuse of `Observation` and `ObservableProperty`.
- OWL‑Time: reserved for future time intervals/dosing windows.
- QUDT: units via `unit:*` IRIs; full quantity pattern is a post‑0.1 upgrade.

Machine‑readable mapping: `ontology/pcdo-align.ttl`. Rationale: `docs/ALIGNMENTS.md`.

## SHACL Validation
Shapes in `shapes/pcdo-shapes.ttl` check:
- Dataset: DOI pattern `^10\.\d{4,9}/.+`, ≥1 creator, title, publisher, year, license IRI, `resourceTypeGeneral`, and a link to a study.
- Study: ≥1 cohort and ≥1 outcome measure; `isRandomized`, `isBlinded`, `sampleSize > 0`.
- Cohort: ≥1 subject.
- Subject: species is `NCBITaxon:*`, sex in {male, female, unknown}, positive age and weight.
- Intervention: agent `CHEBI:*`, dose value > 0 with QUDT unit IRI.
- Observation: `observedProperty`, `hasFeatureOfInterest`, and `resultTime` present.
- Optional: ORCID URL format on `schema:Person` if used.

## Examples
- Minimal valid instance: `examples/abox-minimal.ttl` — mouse study, single cohort, drug intervention, one outcome and observation, DOI and DataCite fields.
- Expected failures: `examples/abox-edge-cases.ttl` — missing DOI, invalid ORCID, zero/negative values, missing species/sex, missing outcome measure.

## Queries (Competency Questions)
- `queries/cq-datasets-ready-for-datacite.rq` — datasets that meet minimal DataCite requirements.
- `queries/cq-invivo-rodent-studies.rq` — animal studies by taxon (general pattern; refine as needed).
- `queries/cq-interventions-by-agent.rq` — group interventions by agent, show dose ranges.
- `queries/cq-outcomes-by-assay.rq` — outcome measures per assay and count observations.
- `queries/cq-missing-ethics.rq` — datasets without ethics approval.

Example (Apache Jena arq):
```
arq --data=ontology/pcdo.ttl --data=examples/abox-minimal.ttl --query=queries/cq-datasets-ready-for-datacite.rq
```

## JSON‑LD for Developers
Use the latest context `ontology/context.jsonld` or pin a version (recommended for production) `ontology/context/0.1.jsonld`.

Example using the versioned context:
```json
{
  "@context": "https://w3id.org/preclindo/ontology/context/0.1.jsonld",
  "@id": "https://example.org/ds/PCDO_Dataset_1",
  "@type": "Dataset",
  "title": "Open preclinical dataset: Drug X in C57BL/6J mice",
  "issued": "2024",
  "license": "https://creativecommons.org/licenses/by/4.0/",
  "creator": ["https://orcid.org/0000-0002-1825-0097"],
  "publisher": "https://ror.org/03yrm5c26",
  "identifierValue": "10.1234/example.doi",
  "describesStudy": "https://example.org/study/S1"
}
```

## Quickstart
- Install dependencies
  - Python 3.11+ and `pip`
  - `pip install -r tooling/requirements.txt`
- Validate locally
  - PowerShell: `./tooling/validate.ps1 -Install`
  - Or: `python tooling/validate.py`
- CI
  - GitHub Actions `Validate Ontology` runs on PRs and main; fails build on SHACL non‑conformance.

### ROBOT Build (artifacts and imports)
- One‑shot script
  - `bash tooling/robot-build.sh`
- Makefile targets (Linux/macOS/WSL/CI)
  - `make ROBOT=robot imports` — generate `imports/*.owl` via MIREOT (OBI/IAO)
  - `make ROBOT=robot convert` — produce `dist/pcdo.owl` and `dist/pcdo.jsonld`
  - `make ROBOT=robot report` — write `reports/robot-report.tsv`
  - `make ROBOT=robot reason` — produce `dist/pcdo-reasoned.ttl` with HermiT

Note: Replace `OWNER/REPO` in the badges with your GitHub org/repo slug to activate status badges.

## Programmatic Usage (Python)
```python
from rdflib import Graph
from pyshacl import validate

ont = Graph().parse('ontology/pcdo.ttl', format='turtle')
ali = Graph().parse('ontology/pcdo-align.ttl', format='turtle')
meta = Graph().parse('ontology/pcdo-metadata.ttl', format='turtle')
sh   = Graph().parse('shapes/pcdo-shapes.ttl', format='turtle')
abox = Graph().parse('examples/abox-minimal.ttl', format='turtle')

data = ont + ali + meta + abox
conforms, report_graph, report_text = validate(
    data_graph=data,
    shacl_graph=sh,
    inference='rdfs',
    abort_on_error=False,
    meta_shacl=False,
    advanced=True,
)
print('Conforms:', conforms)
print(report_text)
```

## Publishing
- Reserve w3id: `https://w3id.org/preclindo` → GitHub Pages or docs site.
- Distribute: `ontology/*.ttl`, `ontology/context.jsonld`, `docs/*`.
- Optional registry: LOV, BioPortal/OLS when scope stabilizes.

## Versioning and Governance
- Semantic versioning with `owl:versionIRI`.
- Deprecations: mark terms with `owl:deprecated true` and provide replacements.
- Change log: `docs/CHANGELOG.md`.

## Contributing
- Open an issue for proposed terms, alignments, or constraints.
- Pull requests should include: updated ontology, shapes/tests, examples (valid/invalid), and queries if applicable.
- Style: keep TBox minimal; push pragmatics to SHACL; prefer OBO identifiers for biomedical concepts.

## License
- Ontology text: CC BY 4.0. Check upstream licenses of referenced vocabularies.

## Citation
If you use PCDO, cite this repository and include the version IRI, for example:
> Preclinical DataCite Ontology (PCDO), version 0.1.0, https://w3id.org/preclindo/ontology/pcdo/0.1.0

## Roadmap
- 0.1 (this release): minimal classes, alignments, SHACL, examples, JSON‑LD, CI.
- 0.2: optional time interval class aligned to OWL‑Time, richer study arm/cohort semantics.
- 0.3: QUDT quantity pattern for doses and body mass; observation collections.
- 1.0: governance docs, w3id redirects, registry submissions, extended competency queries.

## FAQ
- Why SHACL instead of OWL restrictions? SHACL expresses practical validation (patterns, numeric bounds) without over‑constraining inference.
- Do I have to use QUDT now? No. Use simple numbers + `unit:*` IRIs; migrate to `qudt:QuantityValue` later.
- How are creators modeled? As IRIs (e.g., ORCID) linked via `dcterms:creator`. SHACL can enforce ORCID patterns where desired.
- Can I add my ELN/LIMS fields? Yes. Extend with subproperties or separate modules; keep the core lean.

---
For implementation details and alignments, see `docs/MODEL.md` and `docs/ALIGNMENTS.md`. For changes, see `docs/CHANGELOG.md`.
