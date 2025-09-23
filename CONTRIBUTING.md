# Contributing to PCDO

Thanks for your interest in improving the Preclinical DataCite Ontology (PCDO)!

- Discuss changes first by opening an issue with the use case and proposed terms/alignments.
- Keep the core ontology (TBox) minimal; prefer SHACL for data constraints.
- Prefer OBO identifiers (NCBITaxon, CHEBI, PATO, OBI, IAO) for biomedical concepts.
- Provide labels and textual definitions (IAO:0000115) for new terms.
- Include examples: add one valid and one invalid ABox per new feature.
- Update queries and docs if your changes affect them.

## Development
- Edit `ontology/pcdo.ttl` for core terms; `ontology/pcdo-align.ttl` for alignments.
- Validate locally with `python tooling/validate.py`.
- Use ROBOT tasks to generate imports and release artifacts (see Makefile).

## Code of Conduct
Be respectful and collaborative; assume good intentions; value evidence and clear rationale.

## License
By contributing, you agree your contributions are licensed under CC BY 4.0.
