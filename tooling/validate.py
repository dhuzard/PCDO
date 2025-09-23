import sys
from rdflib import Graph
from pyshacl import validate

def parse_graph(paths):
    g = Graph()
    for p in paths:
        g.parse(p, format='turtle')
    return g

def run_validation(data: Graph, sh: Graph):
    return validate(
        data_graph=data,
        shacl_graph=sh,
        inference='rdfs',
        abort_on_error=False,
        meta_shacl=False,
        advanced=True,
    )

def main():
    try:
        base = parse_graph([
            'ontology/pcdo.ttl',
            'ontology/pcdo-align.ttl',
            'ontology/pcdo-metadata.ttl',
            'vocab/routes.ttl',
        ])
        sh = parse_graph(['shapes/pcdo-shapes.ttl'])
    except Exception as e:
        print(f'Parse error: {e}', file=sys.stderr)
        sys.exit(1)

    # Validate minimal example (should conform)
    minimal = base + parse_graph(['examples/abox-minimal.ttl'])
    conforms, _, report = run_validation(minimal, sh)
    print('Minimal example conforms:', conforms)
    if not conforms:
        print(report)
        sys.exit(2)

    # Validate edge cases (should NOT conform)
    edge = base + parse_graph(['examples/abox-edge-cases.ttl'])
    e_conforms, _, e_report = run_validation(edge, sh)
    print('Edge cases conform (expected False):', e_conforms)
    if e_conforms:
        print('Edge cases unexpectedly conform. Review shapes.')
        sys.exit(3)

    print('Validation completed successfully.')
    sys.exit(0)

if __name__ == '__main__':
    main()
