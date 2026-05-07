# Examples

Drop-in configurations for various integration points. None of these are required - pick what fits your workflow.

| File | What it's for |
|------|---------------|
| `pre-commit-config.yaml` | Pre-commit hook that runs both linters on changed files before each commit |
| `workflow-combined.yml` | Single GitHub Actions workflow running both linters as parallel jobs (alternative to the split workflows in `.github/workflows/`) |
| `vscode-tasks.json` | VS Code tasks for running the linters from the editor |
| `gitlab-ci.yml` | GitLab CI equivalent of the GitHub Actions workflows |
| `fixtures/good/` | Minimal valid config and SQF files - used by the self-test workflow |
| `fixtures/bad/` | Intentionally broken files - used by the self-test workflow to confirm the linters still catch errors |

See [`docs/ci-setup.md`](../docs/ci-setup.md) for full integration instructions.

## On the fixtures

The fixtures are intentionally tiny. They're not meant to demonstrate every rule - for that, see the per-tool rule references ([config](../docs/rules-config.md), [sqf](../docs/rules-sqf.md)). They exist to give the self-test something concrete to run against, and to give new contributors a known-good starting point if they want to add a fixture for a specific bug.

If you're adapting this template for your own mod, you can delete the `examples/` directory entirely. The self-test workflow depends on `examples/fixtures/`, so delete that workflow too if you don't want it.
