# REPLACE-ME

A standalone configuration that owns its state.

## First run

```sh
cp backend.hcl.example backend.hcl            # bucket, key, region
cp terraform.tfvars.example terraform.tfvars  # account_id, project
tofu init -backend-config=backend.hcl
tofu plan -out=tfplan
tofu apply tfplan
```

Without AWS access: `tofu init -backend=false && tofu validate`.

## What is deliberately here

- `allowed_account_ids` in the provider: plan/apply against the wrong account
  stops before any API call.
- `default_tags` from a variable: one place for tags, extended per environment.
- Partial S3 backend with `use_lockfile`: no secrets or account ids in git.

## Checks

```sh
tofu fmt -check -recursive
tofu validate
tflint --init && tflint
```
