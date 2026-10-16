# REPLACE-ME (Terragrunt)

Layout adapted from `aws-community-central-asia-2026/infra`:

```
root.hcl                 state, provider, retries — included by every unit
local.hcl.example        per-person account/region (copy to local.hcl, gitignored)
modules/<name>/          plain Terraform; no provider, no backend
units/<name>/            terragrunt.hcl: which module, which inputs, dependencies
stacks/<env>/            terragrunt.stack.hcl: which units make an environment
```

`get_repo_root()` is used for paths, so this directory must be the root of a
git repository (or adjust the paths).

## First run

```sh
git init
cp local.hcl.example local.hcl   # or export TG_ACCOUNT_ID / TG_REGION
cd units/example && terragrunt plan
cd stacks/dev && terragrunt stack run plan
```

## Adding a unit

1. `modules/<name>/` with versions/variables/main/outputs (copy `modules/example`).
2. `units/<name>/terragrunt.hcl` (copy `units/example`), set `source` and inputs,
   add `dependency` blocks with `mock_outputs` for plan.
3. A `unit` block in each stack that needs it.

Long-lived guards (budgets, alarms) belong in their own unit outside the
ephemeral stacks, so a stack destroy cannot remove what is meant to catch it.

## Checks

```sh
terragrunt hcl fmt --check
cd modules/<name> && tofu init -backend=false && tofu validate
```
