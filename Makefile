INCAN ?= incan
INCAN_FLAGS ?= --locked
PYTHON ?= python3

.PHONY: fmt lib test consumer example boundary docs ci

fmt:
	$(INCAN) fmt --check .

lib:
	$(INCAN) build --lib $(INCAN_FLAGS)

test:
	$(INCAN) test tests $(INCAN_FLAGS) --fail-on-empty

consumer: lib
	cd workspaces/external-consumer && $(INCAN) test tests $(INCAN_FLAGS) --fail-on-empty

example: lib
	cd examples/minimal_governed_agent && $(INCAN) run src/main.incn $(INCAN_FLAGS)

boundary:
	bash tools/validation/check_framework_boundary.sh

docs:
	$(PYTHON) -m mkdocs build --strict --config-file workspaces/docs-site/mkdocs.yml

ci: fmt lib test consumer example boundary docs
