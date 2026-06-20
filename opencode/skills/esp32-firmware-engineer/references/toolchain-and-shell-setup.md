# ESP-IDF Toolchain and Environment Activation (ESP32/ESP-IDF)

Use this reference before build/flash/monitor operations when `idf.py` may not already be available in the current shell.

## Pre-Build Toolchain Rule

- Before running `idf.py build`, verify ESP-IDF is actually usable:
  - `idf.py` resolves
  - `idf.py --version` succeeds
- Do not assume the toolchain is installed because a path exists or an older shell once worked.

## Minimum Preflight Checks

- `command -v idf.py`
- `idf.py --version`
- `python3 --version` (when the project's ESP-IDF workflow or helper tooling requires Python)

## Environment Activation Strategy

If `idf.py --version` fails:

1. Read project instructions (`AGENTS.md`) for the exact ESP-IDF environment activation command.
2. If the project does not define one, use the user's documented activation method if one exists.
3. If no documented activation method exists, ask the user for the correct activation command.
4. Do not guess common install paths or modify shell configuration as part of normal task flow.

## Agent Behavior

- If build preflight fails, resolve the correct environment activation method before attempting the build.
- After toolchain preflight, run plugin/framework compatibility preflight before building when ESP-ADF/ESP-SR/etc. are used.
- Do not inject shell profile snippets or aliases unless the user explicitly asks for shell setup help.

## Review Checklist

- Build preflight checks run before build/flash/monitor.
- Plugin/framework compatibility evidence is checked before build for stacks that use ESP-ADF/ESP-SR/etc.
- The ESP-IDF activation command comes from project instructions, a documented user method, or direct user confirmation.
- No shell profile or alias changes are proposed unless the user explicitly requested shell setup work.
