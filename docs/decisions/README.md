# Architecture decisions

Use ADRs for decisions that have lasting architectural consequences and whose rationale would otherwise be rediscovered or disputed later.

Do not create an ADR for routine implementation details, temporary experiments, formatting choices, or facts already obvious from code.

## Naming

Use a stable sequence plus short slug, for example:

`ADR-0001-use-postgresql-for-primary-storage.md`

Start from `ADR-TEMPLATE.md`.

## Lifecycle

- `proposed` — under consideration; not authoritative.
- `accepted` — current decision and part of repository evidence.
- `superseded` — replaced; link to the newer ADR.
- `rejected` — considered but not adopted.

When implementation and an accepted ADR disagree, investigate rather than silently choosing whichever is more convenient. Runtime/code evidence may reveal that the ADR became stale and needs correction.
