# Development

Run the complete local gate with released Incan `0.4.0`:

```bash
make ci INCAN=/path/to/incan
```

The default uses locked dependency resolution and permits a clean machine to populate Cargo's cache. Once dependencies are present, `INCAN_FLAGS="--locked --offline"` provides an additional dependency-resolution check; the packaged replay executable itself is already network-independent.

The gate includes:

- formatting checks;
- a locked public-library build;
- positive and adversarial package/runtime tests;
- an actual external Incan dependency test;
- the fictional external runtime example;
- the fail-closed repository boundary audit; and
- a strict documentation build.

Changes to the initial console profile or application also require:

```bash
make console-test console-native-smoke \
  INCAN=/path/to/incan-0.4.0/bin/incan
```

Those gates compile the native Incan Console, run the direct profile and application suite, and execute all four offline scenarios through the real Hees profile. The domain JSON Schemas constrain provider-facing shape; profile authority and public reason selection remain inside the Hees profile.

## Release-candidate archive

Build a local candidate only with the released toolchain for the current native target:

```bash
make console-release-candidate \
  INCAN=/path/to/incan-0.4.0/bin/incan \
  RELEASE_PLATFORM=macos-aarch64
```

The candidate-platform registry is `workspaces/hees-console/packaging/release-platforms.json`. It pins the exact official Incan archive, SHA-256, target architecture, and standard hosted runner for Linux x86_64, macOS ARM64, and macOS x86_64. The command fails when the executing host does not match the selected target. Windows and Linux ARM64 have no Incan `0.4.0` native release archive and are excluded.

For a fixed source tree, the gate:

1. reruns the package and release-contract tests;
2. audits the native bundle after remapping build paths, including checks for active credential values in the bundle;
3. embeds exactly the native Console binary, project license, repository notice, third-party license report, and release manifest, while keeping the build-side smoke oracle out of the artifact;
4. writes `RELEASE-MANIFEST.json` with the source commit, clean-tree evidence, candidate platform, Incan release identity, Console lock digest, notice digests, and binary hash;
5. creates a normalized `hees-console-<version>-<platform>.tar.gz` plus adjacent `.sha256`; and
6. extracts and executes that archive from a clean temporary working directory with a minimal environment, temporary home, and no API key.

The smoke proves that the candidate does not need a separately installed Incan compiler, package manager, source checkout, provider credential, or network service. It does not prove that the process is physically network-sandboxed, that a different operating-system build works, that native compiler output is bit-reproducible, or that an unsigned macOS artifact carries publisher identity.

The matching GitHub Actions workflow derives its matrix from the same registry and uses immutable action revisions with read-only repository permission. It uploads short-lived candidate evidence and never creates a release or deployment. A platform remains a candidate until its extracted hosted artifact has run successfully. macOS outputs are ad-hoc signed where the toolchain requires it, but they are not publisher-signed or notarized.

Public symbols must be re-exported deliberately from `src/lib.incn`. A change that claims a new guarantee needs a test that fails when the guarantee is violated and documentation that distinguishes the guarantee from caller-owned work.

Do not add client packages, corpora, private source material, generated model artifacts, research benchmarks, provider spikes, or product control surfaces. Use fictional data in tests and examples.
