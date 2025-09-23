# w3id request (preclindo)

Reserve `https://w3id.org/preclindo` and configure redirects:
- `https://w3id.org/preclindo/ontology/pcdo` → raw TTL (latest) and/or HTML docs via content negotiation.
- `https://w3id.org/preclindo/ontology/pcdo/0.1.0` → versioned TTL/OWL/JSON-LD.
- `https://w3id.org/preclindo/ontology/context.jsonld` → JSON-LD context.
- `https://w3id.org/preclindo/imports/*` → import module files.

See https://github.com/perma-id/w3id.org for PR instructions. Provide `.htaccess` (or JSON routes) mapping to GitHub Pages or raw file URLs.
