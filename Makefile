ROBOT ?= robot

TERMS_OBI = \
  http://purl.obolibrary.org/obo/OBI_0000066 \
  http://purl.obolibrary.org/obo/OBI_0000070 \
  http://purl.obolibrary.org/obo/OBI_0000747

TERMS_IAO = \
  http://purl.obolibrary.org/obo/IAO_0000311 \
  http://purl.obolibrary.org/obo/IAO_0000115

PURL_OBI = http://purl.obolibrary.org/obo/obi.owl
PURL_IAO = http://purl.obolibrary.org/obo/iao.owl

DIST = dist
REPORTS = reports

.PHONY: all imports convert report reason clean

all: imports convert report

imports: imports/obi_import.owl imports/iao_import.owl

imports/obi_import.owl:
	@mkdir -p imports
	$(ROBOT) extract \
	  --method MIREOT \
	  --input $(PURL_OBI) \
	  $(foreach t,$(TERMS_OBI),--term $(t)) \
	  --intermediates minimal \
	  --output $@

imports/iao_import.owl:
	@mkdir -p imports
	$(ROBOT) extract \
	  --method MIREOT \
	  --input $(PURL_IAO) \
	  $(foreach t,$(TERMS_IAO),--term $(t)) \
	  --intermediates minimal \
	  --output $@

convert:
	@mkdir -p $(DIST)
	$(ROBOT) convert -I ontology/pcdo.ttl -o $(DIST)/pcdo.owl
	$(ROBOT) convert -I ontology/pcdo.ttl -o $(DIST)/pcdo.jsonld

report:
	@mkdir -p $(REPORTS)
	$(ROBOT) report -I ontology/pcdo.ttl -o $(REPORTS)/robot-report.tsv

reason:
	@mkdir -p $(DIST)
	$(ROBOT) reason -I ontology/pcdo.ttl -r hermit -o $(DIST)/pcdo-reasoned.ttl

clean:
	rm -rf $(DIST) $(REPORTS)
