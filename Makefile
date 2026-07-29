INCAN ?= incan
INCAN_FLAGS ?= --locked
MDBOOK ?= mdbook
CARGO_ABOUT ?= cargo-about
CARGO_DENY ?= cargo-deny
CONSOLE_ROOT := workspaces/hees-console
HEES_MEMBER := hees_ai
CONSOLE_SOURCE := src/main.incn
CONSOLE_NATIVE_TEST := tests/native_console_test.incn
CONSOLE_PROVIDER_TEST := tests/test_provider.incn
CONSOLE_LOCK := $(abspath incan.lock)
CONSOLE_BINARY := $(abspath $(CONSOLE_ROOT)/target/incan/hees_console/target/release/hees_console)
CONSOLE_BUILD_REPORT := $(abspath $(CONSOLE_ROOT)/target/release-evidence/build-report.json)
CONSOLE_RELEASE_TOOL := $(abspath $(CONSOLE_ROOT)/packaging/release_candidate.sh)
CONSOLE_RELEASE_TEST := $(abspath $(CONSOLE_ROOT)/packaging/test_release_candidate.sh)
CONSOLE_RELEASE_SET_TOOL := $(abspath $(CONSOLE_ROOT)/packaging/validate_release_set.sh)
CONSOLE_RELEASE_SET_TEST := $(abspath $(CONSOLE_ROOT)/packaging/test_release_set.sh)
DOCS_PAGES_TOOL := $(abspath workspaces/docs-site/packaging/prepare_pages.sh)
DOCS_PAGES_TEST := $(abspath workspaces/docs-site/packaging/test_prepare_pages.sh)
DOCS_PAGES_PUBLISH_TOOL := $(abspath workspaces/docs-site/packaging/publish_pages.sh)
DOCS_PAGES_PUBLISH_TEST := $(abspath workspaces/docs-site/packaging/test_publish_pages.sh)
CONSOLE_GENERATED_ROOT := $(abspath $(CONSOLE_ROOT)/target/incan/hees_console)
CONSOLE_RUNNER_ROOT := $(abspath $(CONSOLE_ROOT)/runner)
CONSOLE_RUNNER_BINARY := $(CONSOLE_RUNNER_ROOT)/target/incan/hees_runner/target/release/hees_runner
CONSOLE_COMPATIBILITY_ROOT := $(abspath $(CONSOLE_ROOT)/contracts/domain/kernel_compatibility)
CONSOLE_GENERATED_LICENSE_REPORT := $(abspath $(CONSOLE_ROOT)/target/release-evidence/THIRD_PARTY_LICENSES.md)
LICENSE_CONFIG_ROOT := $(abspath tools/licenses)
INCAN_RESOLVED := $(shell command -v "$(INCAN)" 2>/dev/null || printf '%s' "$(INCAN)")
INCAN_RELEASE_ROOT := $(abspath $(dir $(INCAN_RESOLVED))/..)
INCAN_PROVIDER_HOME := $(abspath $(if $(INCAN_HOME),$(INCAN_HOME),$(HOME)/.incan))
CONSOLE_RUSTFLAGS := --remap-path-prefix=$(HOME)=/toolchain-home --remap-path-prefix=$(abspath .)=/hees-source --remap-path-prefix=$(INCAN_RELEASE_ROOT)=/incan-toolchain --remap-path-prefix=$(INCAN_PROVIDER_HOME)=/incan-provider-cache $(if $(INCAN_TOOLCHAIN_CRATES_DIR),--remap-path-prefix=$(INCAN_TOOLCHAIN_CRATES_DIR)=/incan-toolchain-crates) $(if $(INCAN_STDLIB),--remap-path-prefix=$(INCAN_STDLIB)=/incan-stdlib)
INCAN_REQUIRED_VERSION := incan 0.5.0-dev.32
RELEASE_OUTPUT ?= $(abspath $(CONSOLE_ROOT)/target/release)
RELEASE_PLATFORM ?=
PAGES_OUTPUT ?=
PAGES_REMOTE ?=
PAGES_BRANCH ?=
SOURCE_COMMIT ?= $(shell git rev-parse HEAD)
SOURCE_DATE_EPOCH ?= $(shell git show -s --format=%ct HEAD)

.PHONY: fmt lib test consumer example boundary boundary-self-test docs docs-pages-contract-test docs-pages-publish-contract-test docs-pages-stage docs-pages-publish ci console-build console-test console-runner-build console-kernel-compatibility console-native-smoke console-license-audit console-release-candidate console-release-contract-test console-release-set-test console-release-lint

fmt:
	$(INCAN) fmt --check .

lib:
	$(INCAN) build --lib --member $(HEES_MEMBER) $(INCAN_FLAGS)

test:
	$(INCAN) test --member $(HEES_MEMBER) tests $(INCAN_FLAGS) --fail-on-empty

consumer: lib
	cd workspaces/external-consumer && $(INCAN) test tests $(INCAN_FLAGS) --fail-on-empty

example: lib
	cd examples/minimal_governed_agent && $(INCAN) run src/main.incn $(INCAN_FLAGS)

boundary:
	bash tools/validation/check_framework_boundary.sh

boundary-self-test:
	bash tools/validation/test_framework_boundary.sh

docs:
	$(MDBOOK) build workspaces/docs-site

docs-pages-contract-test:
	$(DOCS_PAGES_TEST)

docs-pages-publish-contract-test:
	$(DOCS_PAGES_PUBLISH_TEST)

docs-pages-stage: docs
	@test -n "$(PAGES_OUTPUT)" || { echo "PAGES_OUTPUT is required" >&2; exit 1; }
	$(DOCS_PAGES_TOOL) --site workspaces/docs-site/site --destination "$(PAGES_OUTPUT)" --source-commit "$(SOURCE_COMMIT)"

docs-pages-publish:
	@test -n "$(PAGES_OUTPUT)" || { echo "PAGES_OUTPUT is required" >&2; exit 1; }
	@test -n "$(PAGES_REMOTE)" || { echo "PAGES_REMOTE is required" >&2; exit 1; }
	@test -n "$(PAGES_BRANCH)" || { echo "PAGES_BRANCH is required" >&2; exit 1; }
	$(DOCS_PAGES_PUBLISH_TOOL) --site "$(PAGES_OUTPUT)" --source-commit "$(SOURCE_COMMIT)" --remote "$(PAGES_REMOTE)" --branch "$(PAGES_BRANCH)" --publish

console-build:
	@test "$$($(INCAN) --version)" = "$(INCAN_REQUIRED_VERSION)" || { echo "hees.ai console requires $(INCAN_REQUIRED_VERSION)" >&2; exit 1; }
	@mkdir -p "$(dir $(CONSOLE_BUILD_REPORT))"
	RUSTFLAGS="$(CONSOLE_RUSTFLAGS)" $(INCAN) build --lib --member $(HEES_MEMBER) $(INCAN_FLAGS)
	cd $(CONSOLE_ROOT) && RUSTFLAGS="$(CONSOLE_RUSTFLAGS)" $(INCAN) build $(CONSOLE_SOURCE) $(INCAN_FLAGS) --release --report json --report-output $(CONSOLE_BUILD_REPORT)
	@test -x "$(CONSOLE_BINARY)" || { echo "pinned Incan did not emit $(CONSOLE_BINARY)" >&2; exit 1; }

console-test:
	@test "$$($(INCAN) --version)" = "$(INCAN_REQUIRED_VERSION)" || { echo "hees.ai console requires $(INCAN_REQUIRED_VERSION)" >&2; exit 1; }
	cd $(CONSOLE_ROOT) && $(INCAN) test $(CONSOLE_NATIVE_TEST) $(INCAN_FLAGS) --fail-on-empty
	cd $(CONSOLE_ROOT) && $(INCAN) test $(CONSOLE_PROVIDER_TEST) $(INCAN_FLAGS) --fail-on-empty

console-runner-build:
	@test "$$($(INCAN) --version)" = "$(INCAN_REQUIRED_VERSION)" || { echo "hees.ai console requires $(INCAN_REQUIRED_VERSION)" >&2; exit 1; }
	cd $(CONSOLE_RUNNER_ROOT) && RUSTFLAGS="$(CONSOLE_RUSTFLAGS)" $(INCAN) build src/main.incn $(INCAN_FLAGS) --release
	@test -x "$(CONSOLE_RUNNER_BINARY)" || { echo "pinned Incan did not emit $(CONSOLE_RUNNER_BINARY)" >&2; exit 1; }

console-kernel-compatibility:
	@test "$$($(INCAN) --version)" = "$(INCAN_REQUIRED_VERSION)" || { echo "hees.ai console requires $(INCAN_REQUIRED_VERSION)" >&2; exit 1; }
	cd $(CONSOLE_COMPATIBILITY_ROOT) && $(INCAN) run src/main.incn $(INCAN_FLAGS)

console-native-smoke: console-build
	$(CONSOLE_RELEASE_TOOL) smoke-binary --binary $(CONSOLE_BINARY)

console-license-audit: console-build
	$(CARGO_DENY) --manifest-path $(CONSOLE_GENERATED_ROOT)/Cargo.toml check --config $(LICENSE_CONFIG_ROOT)/deny.toml licenses
	$(CARGO_ABOUT) generate $(LICENSE_CONFIG_ROOT)/third-party-licenses.hbs --config $(LICENSE_CONFIG_ROOT)/about.toml --manifest-path $(CONSOLE_GENERATED_ROOT)/Cargo.toml --locked --offline --fail --output-file $(CONSOLE_GENERATED_LICENSE_REPORT)
	@test -s $(CONSOLE_GENERATED_LICENSE_REPORT)
	@grep -Fq '# Third-party licenses' $(CONSOLE_GENERATED_LICENSE_REPORT)
	@grep -Fq '## ' $(CONSOLE_GENERATED_LICENSE_REPORT)

console-release-contract-test:
	$(CONSOLE_RELEASE_TEST)

console-release-set-test:
	$(CONSOLE_RELEASE_SET_TEST)

console-release-lint:
	sh -n $(CONSOLE_RELEASE_TOOL) $(CONSOLE_RELEASE_TEST) $(CONSOLE_RELEASE_SET_TOOL) $(CONSOLE_RELEASE_SET_TEST) $(DOCS_PAGES_TOOL) $(DOCS_PAGES_TEST) $(DOCS_PAGES_PUBLISH_TOOL) $(DOCS_PAGES_PUBLISH_TEST)
	shellcheck -s sh $(CONSOLE_RELEASE_TOOL) $(CONSOLE_RELEASE_TEST) $(CONSOLE_RELEASE_SET_TOOL) $(CONSOLE_RELEASE_SET_TEST) $(DOCS_PAGES_TOOL) $(DOCS_PAGES_TEST) $(DOCS_PAGES_PUBLISH_TOOL) $(DOCS_PAGES_PUBLISH_TEST)
	actionlint .github/workflows/console-release-candidate.yml .github/workflows/console-draft-release.yml .github/workflows/docs.yml

console-release-candidate: console-release-contract-test console-test console-native-smoke console-license-audit
	@test -n "$(RELEASE_PLATFORM)" || { echo "RELEASE_PLATFORM is required" >&2; exit 1; }
	$(CONSOLE_RELEASE_TOOL) validate-platform --platform "$(RELEASE_PLATFORM)"
	THIRD_PARTY_LICENSES_SOURCE="$(CONSOLE_GENERATED_LICENSE_REPORT)" $(CONSOLE_RELEASE_TOOL) package --binary "$(CONSOLE_BINARY)" --platform "$(RELEASE_PLATFORM)" --output-directory "$(RELEASE_OUTPUT)" --source-commit "$(SOURCE_COMMIT)" --source-date-epoch "$(SOURCE_DATE_EPOCH)" --incan-root "$(INCAN_RELEASE_ROOT)" --incan-lock "$(CONSOLE_LOCK)" --forbidden "$(abspath .)" --forbidden "$(HOME)" --forbidden "$(INCAN_RELEASE_ROOT)" --forbidden "$(INCAN_PROVIDER_HOME)"
	$(CONSOLE_RELEASE_TOOL) smoke-archive --archive "$(RELEASE_OUTPUT)/hees-console-0.1.0-$(RELEASE_PLATFORM).tar.gz" --platform "$(RELEASE_PLATFORM)" --forbidden "$(abspath .)" --forbidden "$(HOME)" --forbidden "$(INCAN_RELEASE_ROOT)" --forbidden "$(INCAN_PROVIDER_HOME)"

ci: fmt lib test consumer example boundary boundary-self-test docs docs-pages-contract-test docs-pages-publish-contract-test console-test console-runner-build console-kernel-compatibility console-release-contract-test console-release-set-test
