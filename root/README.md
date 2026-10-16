# REPLACE-ME

A standalone configuration that owns its state.

```
backend.tf               backend type and settings shared by every environment
envs/dev.s3.tfbackend    where dev state lives (bucket, key, region)   committed
envs/dev.tfvars          non-secret dev values                          committed
providers.tf             allowed_account_ids, default_tags
.terraform.lock.hcl      created by init                                committed
terraform.tfvars         personal overrides, if any                     gitignored
```

## First run

```sh
# right after -from-module ... -backend=false: fill envs/dev.*, then
tofu init -backend-config=envs/dev.s3.tfbackend
tofu plan -var-file=envs/dev.tfvars -out=tfplan
tofu apply tfplan
```

Another environment is two more files: `envs/prod.s3.tfbackend` with its own
key, and `envs/prod.tfvars`. Switching between them in one working directory:
`tofu init -reconfigure -backend-config=envs/prod.s3.tfbackend`.

Without AWS access: `tofu init -backend=false && tofu validate`.

## What is deliberately here

- `allowed_account_ids` in the provider: plan/apply against the wrong account
  stops before any API call.
- `default_tags` from a variable: one place for tags, extended per environment.
- Partial S3 backend with `use_lockfile`: no DynamoDB table, no credentials in
  any file.

## Checks

```sh
tofu fmt -check -recursive
tofu validate
tflint --init && tflint
```
