---
name: grill-with-docs
description: Relentless interview to sharpen a plan or design while maintaining CONTEXT.md glossary and ADR docs. Use when the user says /grill-with-docs or wants grilling plus docs.
---

# Grill With Docs

Interview the user relentlessly about every aspect of the current plan or design until you reach shared understanding.

Walk down each branch of the design tree, resolving dependencies between decisions one by one. For each question, provide your recommended answer.

Ask one question at a time, then wait for feedback before continuing. Asking multiple questions at once is bewildering.

If a question can be answered by exploring the codebase, explore the codebase instead of asking the user.

## Documentation Discipline

Build and sharpen the project's domain model as you design. Challenge vague terms, propose precise canonical terms, discuss concrete edge cases, and cross-reference with code when claims about behavior can be checked.

When a domain term is resolved, update `CONTEXT.md` immediately. Do not batch these updates. Use `../domain-modeling/CONTEXT-FORMAT.md` as the format reference.

Only offer to create an ADR when all three are true:

1. The decision is hard to reverse.
2. The decision is surprising without context.
3. The decision is the result of a real trade-off.

When creating an ADR, use `../domain-modeling/ADR-FORMAT.md` as the format reference.
