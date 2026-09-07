# Architecture documentation

Create architecture documents here when the repository becomes complex enough that stable boundaries or flows are not obvious from code and normal project documentation.

Useful topics include:

- major components and ownership boundaries
- dependency direction and layering constraints
- important runtime/data flows
- integration boundaries and external systems
- security or trust boundaries
- invariants that implementation must preserve

Keep documents descriptive of the **current** system. Historical rationale belongs in an ADR when it remains important. Do not mirror every source file or generate a giant repository encyclopedia.

Prefer a small `index.md` if this directory grows beyond a few documents, with links and one-line descriptions so agents can retrieve selectively.
