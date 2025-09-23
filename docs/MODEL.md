# PCDO Model Overview

PCDO models the minimum concepts needed to publish preclinical datasets with DataCite while retaining core study semantics.

- Dataset: the DOI-minted deliverable linking to a Study and metadata required by DataCite.
- Study: cohorts, interventions, assays, outcome measures; simple design flags and sample size.
- Cohort/Subject: species (NCBITaxon), sex (PATO), basic demographics (age, weight).
- Intervention: agent (CHEBI), dose value + unit (QUDT unit IRI), route/schedule labels.
- Assay/Observation: connection between outcome measures and measured results.

Constraints are enforced with SHACL rather than complex OWL restrictions to keep the TBox lean.

