# arma3-lint

Two no-dependency linters for Arma 3 mod source, plus the GitHub Actions workflows to run them on every push and PR.

This is a **GitHub template repo**. Click *Use this template* (or copy the files directly) into your mod repo. There is no package to install, no service to subscribe to, no maintainer to chase. You own your copy. If you want a fix, change the script.

## What's in here

| Tool | What it lints | Lines | Deps |
|------|----------------|-------|------|
| `tools/arma_lint.py` | `.cpp` / `.hpp` / `.cfg` config files | ~1500 | Python 3.8+ stdlib |
| `tools/sqf_lint.py`  | `.sqf` script files                  | ~1650 | Python 3.8+ stdlib |

Both are single files. No `pip install`, no Node, no Docker, no Rust toolchain. Drop them in `tools/` in your mod repo and you're done.

## Why this exists

The existing options are mostly dead, heavy, or both:

- **sqflint** (LordGolias) is unmaintained and trips on modern syntax.
- **HEMTT** does this stuff well, but it's a full build system. Not every team is ready for that migration just to get linting.
- **SQF VM** is Java and overkill for "is this file syntactically sane".

There's a real gap for *"drop two Python files in tools/, get linting in five minutes, fail PRs on errors."* That's what this is.

The SQF linter in particular is **structural**, not database-driven. It validates the shape of your code (balanced brackets, well-formed `if/then`, `private` semantics) instead of comparing every identifier against a list of known commands. That means new BI commands and operators just work - there's no command database to keep up to date.

## Quick start (existing repo)

```bash
# From the root of your mod repo:
mkdir -p tools .github/workflows

curl -O https://raw.githubusercontent.com/IsoBones/arma3-lint/main/tools/arma_lint.py
curl -O https://raw.githubusercontent.com/IsoBones/arma3-lint/main/tools/sqf_lint.py
mv arma_lint.py sqf_lint.py tools/

curl -o .github/workflows/configlint.yml \
  https://raw.githubusercontent.com/IsoBones/arma3-lint/main/.github/workflows/configlint.yml
curl -o .github/workflows/sqflint.yml \
  https://raw.githubusercontent.com/IsoBones/arma3-lint/main/.github/workflows/sqflint.yml

# Run it locally
python3 tools/arma_lint.py Addons
python3 tools/sqf_lint.py Addons
```

Commit and push. The workflows will run on the next push and on PRs.

> The example workflows assume your addon source lives in `Addons/`. If yours is `addons/` (lowercase) or `src/` or wherever, edit the paths in the workflow files. CI runs on Linux, which is case-sensitive, so the case has to match what's actually on disk.

## Quick start (new repo from template)

1. Click **Use this template** at the top of [the GitHub repo page](https://github.com/IsoBones/arma3-lint).
2. Clone your new repo.
3. Drop your mod source in (typically into `Addons/`).
4. The workflows already exist. Push and watch them run.
5. Delete `examples/` and `docs/` if you don't want them in your mod repo.

## Default behaviour

Both linters use the same exit codes and flags so they behave identically in CI:

| Exit | Meaning |
|------|---------|
| `0`  | Clean |
| `1`  | Warnings only |
| `2`  | Errors |

The example workflows run with `--no-warnings`, so warnings don't fail the build until you're ready. Once you've cleaned up the existing warnings in your repo, swap `--no-warnings` for `-W` (warnings-as-errors) in the workflow file and CI will start blocking on warnings too.

Both tools support `--rules` to print every rule with its ID and severity, `--disable RULE_ID` to silence individual rules, and `--json` for machine-readable output.

## Per-tool detail

- [`docs/rules-config.md`](docs/rules-config.md) - every rule the config linter checks, with examples
- [`docs/rules-sqf.md`](docs/rules-sqf.md) - every rule the SQF linter checks, with examples
- [`docs/ci-setup.md`](docs/ci-setup.md) - GitHub Actions, GitLab CI, pre-commit, and local dev integration

## Integration options

### GitHub Actions (recommended)

The two workflows in `.github/workflows/` run on every push and PR that touches relevant files. They use `paths:` filters so they don't waste minutes on README-only changes.

### Pre-commit hook

Catches issues before they hit CI. See [`examples/pre-commit-config.yaml`](examples/pre-commit-config.yaml).

```bash
pip install pre-commit
cp examples/pre-commit-config.yaml .pre-commit-config.yaml
pre-commit install
```

### Local one-liner

```bash
python3 tools/arma_lint.py Addons && python3 tools/sqf_lint.py Addons
```

Stick that in a `Makefile` or a `justfile` if you want a `make lint` target.

### VS Code task

See [`examples/vscode-tasks.json`](examples/vscode-tasks.json) for a "Run all linters" task you can bind to a keyboard shortcut.

## When NOT to use this

- **You're already on HEMTT.** `hemtt check` covers everything these linters do and more. Use HEMTT.
- **You need a full SQF type system.** This is a syntax/structure linter, not a type checker. SQF VM or HEMTT's deeper SQF analysis is what you want.
- **You want a Wiki-backed command database.** This linter intentionally doesn't have one. That's a feature for sustainability but means it won't tell you "you used `setvelocity` when you meant `setVelocity`" (case sensitivity is checked elsewhere though).

## License

MIT. Do whatever. Attribution appreciated but not required.

## Contributing

This is a template repo. The expectation is you fork it and own your copy. If you find a real bug or want to share an improvement, PRs are welcome but there's no SLA - treat this as community-shared scaffolding rather than a maintained product.

If you build something useful on top of this (extra rules, alternate output formats, integrations with other CI systems), open a PR or just link it in an issue so others can find it.
