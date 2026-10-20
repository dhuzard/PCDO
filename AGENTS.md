# AGENTS.md — PCDO

## Status and scope
**Preliminary experimental ontology**, intended for practical preclinical/DataCite dataset description and SHACL-based structural checks. Development may resume on concrete interoperability examples, but no stable community standard or validated production ontology is currently asserted. The existing `0.1.0` version IRI does not imply semantic completeness.

## Responsible use
Read `README.md`, `docs/MODEL.md`, `docs/ALIGNMENTS.md`, `ontology/`, `shapes/`, `examples/` and `queries/` before changing the model.
- Prefer existing standards (DataCite, DCAT, PROV, OBI, IAO, SOSA, QUDT and appropriate OBO resources) with explicit imports/crosswalks. Avoid duplicating HCMO or other domain vocabularies without a demonstrated gap.
- Distinguish metadata sufficient to construct a DataCite record from valid DOI registration, archival custody, reuse fitness or scientific validity.
- New ontology classes, alignments and SHACL restrictions require competency questions, positive/negative Turtle fixtures and evidence that the mapping preserves intended meaning.
- Do not silently change published IRIs/version identities or replace exact/close/related relations. Crosswalk uncertainty remains explicit. No speculative term generation from an LLM alone.
- Keep the project documented as experimental and do not initiate external registry/namespace publication without review.

## Checks
```bash
python -m pip install -r tooling/requirements.txt
python tooling/validate.py
```
This verifies the expected passing and failing examples only, not full interoperability or official DataCite compliance. Report observed tests accurately.
