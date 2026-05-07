# Changelog

This is a template repo, so versioning is informal. The intent is to capture meaningful changes for anyone tracking the upstream.

## Unreleased

Initial extraction from the IsoBones/ADFRC mod repo.

### Tools
- `tools/arma_lint.py` - config linter for `.cpp` / `.hpp` / `.cfg`, 19 errors and 17 warnings across structural, preprocessor, CfgPatches, and cosmetic rules. Validates `#include` resolution including case-sensitivity for Linux/CI.
- `tools/sqf_lint.py` - SQF script linter, 16 errors and 16 warnings. Structural rather than database-driven, so modern commands and operators just work.

### Workflows
- `.github/workflows/configlint.yml` and `sqflint.yml` - per-linter workflows with `paths:` filters
- `.github/workflows/self-test.yml` - regression guard that runs the linters against `examples/fixtures/`

### Docs
- Top-level `README.md` covering quick start and template usage
- `docs/rules-config.md` and `docs/rules-sqf.md` - per-rule reference
- `docs/ci-setup.md` - CI, pre-commit, and editor integration

### Examples
- Combined-workflow alternative
- Pre-commit hook config
- VS Code tasks
- GitLab CI equivalent
- Good and bad fixture files for the self-test
