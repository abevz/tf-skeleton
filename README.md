# tf-skeleton

Starting points for OpenTofu/Terraform work. Each directory is copied into an
empty directory with `tofu init -from-module`, which copies and runs init in one
step.

| Skeleton | Use it for | Start with |
| --- | --- | --- |
| [`module/`](module) | a reusable module: no provider, no backend | `tofu init -from-module=~/github/tf-skeleton/module` |
| [`root/`](root) | a standalone configuration that owns state | `tofu init -from-module=~/github/tf-skeleton/root -backend=false` |
| [`terragrunt/`](terragrunt) | several units sharing one backend and provider | `cp -r ~/github/tf-skeleton/terragrunt <dir>` |

`-from-module` needs an **empty** target directory. From a remote copy the
subdirectory goes after `//`:
`tofu init -from-module=git::https://github.com/abevz/tf-skeleton.git//module`.

`-from-module` **skips dotfiles**, so `.gitignore` and `.tflint.hcl` are not
copied. From a clone, `./new.sh module|root|terragrunt <dir>` does the init and
copies them too.

## Conventions every skeleton follows

- `versions.tf` pins `required_version` and every provider with `source` and a
  pessimistic `~>` constraint. Only `hashicorp/*` providers may omit `source`,
  and none here do.
- Variables: `description` → `type` → `default` → `validation` → `nullable` →
  `sensitive`. Every variable and output has a description.
- State goes to S3 with native locking (`use_lockfile = true`, OpenTofu and
  Terraform 1.10+): no DynamoDB table to create, pay for or forget.
- The AWS provider carries `allowed_account_ids`: a wrong-account apply is the
  one mistake that is expensive to undo.
- Tags come in through `default_tags` as a variable, so callers extend the set
  without rewriting the provider block.
- Environment values are committed per environment (`envs/<env>.s3.tfbackend`,
  `envs/<env>.tfvars`); only personal values and secrets are gitignored. Each
  skeleton carries its own `.gitignore`, because `-from-module` copies only the
  subdirectory.

Sources: the module layout and variable contract from the `terraform-skill`
skill; the root/terragrunt practices from `aws-community-central-asia-2026`
(`infra/root.hcl`, `infra/units`, `infra/modules`).

## Checking the skeletons themselves

```sh
./check.sh   # fmt, validate and tflint for every skeleton, tofu test for module/
```
