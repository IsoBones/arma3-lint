# CI and editor integration

The linters are designed to fit into whatever workflow you already have. Pick the integration points that match your team.

## GitHub Actions

Two patterns ship in this repo:

**Split workflows** ([`.github/workflows/configlint.yml`](../.github/workflows/configlint.yml) and [`.github/workflows/sqflint.yml`](../.github/workflows/sqflint.yml))

The default. Each linter runs in its own workflow with its own `paths:` filter, so a PR that only touches SQF doesn't spin up a config-lint job. Easier to read in the PR checks panel because each linter shows up as a distinct check name.

**Combined workflow** ([`examples/workflow-combined.yml`](../examples/workflow-combined.yml))

One workflow file with two parallel jobs. Same total runtime, slightly fewer files to manage. Use this if you prefer fewer YAML files in `.github/workflows/`.

Pick one or the other - don't run both, you'll just lint everything twice.

### Promoting warnings to errors

Both example workflows ship with `--no-warnings`, which hides warnings entirely so they don't fail the build. This lets you adopt the linters without immediately failing on every existing warning in your repo.

Once you've cleaned up the warnings, swap the flag in the workflow:

```yaml
# Before - warnings hidden, only errors fail the build
- run: python3 tools/arma_lint.py Addons --no-warnings

# After - warnings shown AND fail the build
- run: python3 tools/arma_lint.py Addons -W
```

`-W` is `--warnings-as-errors`. CI now blocks on both errors and warnings.

### Disabling individual rules

If a specific rule produces too many false positives in your codebase, disable it:

```yaml
- run: python3 tools/arma_lint.py Addons --no-warnings --disable W014
```

Use `--disable` multiple times for multiple rules. See `python3 tools/arma_lint.py --rules` for the full list.

### Workflow versions

The example workflows pin to the v6 family of `actions/checkout` and `actions/setup-python`. Bump them when the actions release new majors.

If you want automated bumps, drop a `.github/dependabot.yml` in:

```yaml
version: 2
updates:
  - package-ecosystem: "github-actions"
    directory: "/"
    schedule:
      interval: "monthly"
```

## GitLab CI

[`examples/gitlab-ci.yml`](../examples/gitlab-ci.yml) is the GitLab equivalent. Copy to your repo root as `.gitlab-ci.yml`.

The structure is the same: two jobs, one per linter, each gated to only run when relevant files change.

## Pre-commit hook (local, before push)

Catches errors before they hit CI. Faster feedback loop.

```bash
pip install pre-commit
cp examples/pre-commit-config.yaml .pre-commit-config.yaml
pre-commit install
```

Now every `git commit` runs the linters on changed files. Errors block the commit. Warnings don't (drop `--no-warnings` from the args if you want them shown).

To run all hooks against all files (e.g. after first install):

```bash
pre-commit run --all-files
```

To temporarily skip the hooks for a commit:

```bash
git commit --no-verify
```

## VS Code

[`examples/vscode-tasks.json`](../examples/vscode-tasks.json) defines three tasks: lint config, lint SQF, lint both. Drop into `.vscode/tasks.json` in your repo. `Ctrl+Shift+B` runs the default ("Lint all").

You can wire the output into the Problems panel by adding a `problemMatcher`. The linters output in the standard `file:line:column: severity[CODE]: message` format that most editors recognise. A minimal matcher for the SQF linter:

```jsonc
"problemMatcher": {
    "owner": "sqf-lint",
    "fileLocation": ["relative", "${workspaceFolder}"],
    "pattern": {
        "regexp": "^(.+?):(\\d+):(\\d+):\\s+(error|warning|info)\\[([A-Z0-9]+)\\]:\\s+(.+)$",
        "file": 1, "line": 2, "column": 3, "severity": 4, "code": 5, "message": 6
    }
}
```

## Local CLI

```bash
# Default - lint current directory
python3 tools/arma_lint.py
python3 tools/sqf_lint.py

# Specific directories
python3 tools/arma_lint.py Addons
python3 tools/sqf_lint.py Addons/MyAddon

# Multiple paths
python3 tools/arma_lint.py Addons/A Addons/B Addons/C/file.cpp

# JSON output for scripting
python3 tools/sqf_lint.py Addons --json | jq '.findings[] | select(.severity=="error")'

# List every rule the linter knows
python3 tools/arma_lint.py --rules
python3 tools/sqf_lint.py --rules
```

## Make / just

Add a `lint` target if you have a Makefile:

```make
.PHONY: lint
lint:
	python3 tools/arma_lint.py Addons
	python3 tools/sqf_lint.py Addons
```

Or if you use [just](https://github.com/casey/just):

```just
lint:
    python3 tools/arma_lint.py Addons
    python3 tools/sqf_lint.py Addons
```

## Combining with HEMTT

If you're already running `hemtt check` in CI, you don't need these linters - HEMTT covers the same ground and more. The use case for arma3-lint is specifically pre-HEMTT projects, or projects where HEMTT migration is on the roadmap but not done yet. Run these in the meantime, drop them when you switch.
