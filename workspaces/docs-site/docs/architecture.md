# Architecture

The kernel has one public Incan library boundary and two internal modules:

```text
external implementation
  -> package descriptor shape -> package_loader.incn
  -> in-memory package + proposal -> runtime.incn
  -> checked public exports -> lib.incn
```

The external implementation owns concrete domain content, model execution, retrieval, package authoring, and source
rights work. Hees owns only the generic contracts and structural decisions represented here.

A proposal is untrusted. It becomes admitted only after the runtime verifies that:

1. the supplied runtime package is structurally valid;
2. package and domain identifiers match;
3. the proposal contains visible output;
4. the requested action is declared by the package; and
5. each cited evidence identifier refers to an approved, rights-allowed record in the package.

There is deliberately no provider adapter, storage engine, network service, package-file parser, archive format, digest
algorithm, retrieval engine, or Workbench control surface in this repository.
