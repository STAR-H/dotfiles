---
name: cavecrew
description: >
  Use when delegating code search, surgical edits, or diff review to
  caveman-style subagents and compact structured output matters. Trigger:
  "delegate to subagent", "use cavecrew", "spawn
  investigator/builder/reviewer", "save context", "compressed agent output".
---

Cavecrew = three subagent presets that emit caveman-compressed output. Use them when you want locator, surgical-edit, or review work delegated with minimal main-context cost.

## When to use cavecrew vs alternatives

| Task | Use |
|---|---|
| "Where is X defined / what calls Y / list uses of Z" | `cavecrew-investigator` |
| Same but you also want suggestions or architecture commentary | General-purpose explore agent or main thread |
| Surgical edit, ≤2 files, scope obvious | `cavecrew-builder` |
| New feature / 3+ files / cross-cutting refactor | Main thread or full-feature build agent |
| Review diff, branch, or file for bugs | `cavecrew-reviewer` |
| Deep code review with rationale + alternatives | General-purpose review agent |
| One-line answer you already know | Main thread, no subagent |

Rule of thumb: **if you want compact structured output, pick cavecrew. If you want expansive prose or design discussion, use a general-purpose agent. Short is fine. Missing core meaning is not.**

## Why this exists (the real win)

Subagent results get injected into main context. A verbose general-purpose agent can easily return 2k tokens of prose; the same finding from `cavecrew-investigator` is often far smaller. Across many delegations, that difference decides whether context lasts.

## Entry points

This skill is entry-point agnostic. Use it when delegation starts from:
- main-thread reasoning
- a custom command
- a reusable workflow prompt
- manual subagent dispatch

Decision rule stays same: pick smallest cavecrew agent that can finish job.

## Output contracts

What main thread can rely on per agent:

**`cavecrew-investigator`**
```
<Header>:
- path:line — `symbol` — short note
totals: <counts>.
```
Or `No match.` Always file-path-first, line-number-attached, backticked symbols. Safe to grep with `path:\d+`.

**`cavecrew-builder`**
```
<path:line-range> — <change ≤10 words>.
verified: <re-read OK | mismatch @ path:line>.
```
Or one of: `too-big.` / `needs-confirm.` / `ambiguous.` / `regressed.` (terminal first token).

**`cavecrew-reviewer`**
```
path:line: <emoji> <severity>: <problem>. <fix>.
totals: N🔴 N🟡 N🔵 N❓
```
Or `No issues.` Findings sorted file → line ascending.

## Chaining patterns

**Locate → fix → verify** (most common):
1. `cavecrew-investigator` returns site list.
2. Main thread picks 1-2 sites, hands paths to `cavecrew-builder`.
3. `cavecrew-reviewer` audits the diff.

**Parallel scout** (when investigation is broad):
Spawn 2-3 `cavecrew-investigator` calls in one message (different angles: defs vs callers vs tests). Aggregate in main thread.

**Single-shot edit** (when site is already known):
Skip investigator. Hand exact path:line to `cavecrew-builder` directly.

## What NOT to do

- Don't use `cavecrew-builder` when you don't already know the file. Spawn investigator first or main thread will eat tokens passing context.
- Don't chain `cavecrew-investigator → cavecrew-builder` for a 5-file refactor. Builder will return `too-big.` and you'll have wasted a turn.
- Don't ask `cavecrew-reviewer` for "general feedback" — it returns findings only, no architecture opinions. Use a general-purpose review agent for that.
- Don't expect prose. Cavecrew output is structured, sometimes terse to the point of cryptic. If a human will read it directly, paraphrase.

## Auto-clarity (inherited)

Subagents switch from caveman style to clear, normal prose for security warnings, irreversible-action confirmations, and any output where fragment ambiguity could be misread. If user is using Chinese, write clear Simplified Chinese. Keep code and exact technical strings unchanged. Resume caveman after.
