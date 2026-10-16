# REPLACE-ME module

One sentence on what this module creates and why it is a module.

## Usage

```hcl
module "example" {
  source = "../modules/REPLACE-ME"

  name_prefix = "probes-demo"
  tags        = { Component = "example" }
}
```

## Inputs

| Name | Type | Default | Description |
| --- | --- | --- | --- |
| `name_prefix` | `string` | — | Prefix for every resource name. |
| `tags` | `map(string)` | `{}` | Extra tags on top of provider `default_tags`. |

## Outputs

| Name | Description |
| --- | --- |
| `name` | Resolved name prefix. |
| `tags` | Tags the module applies. |

## Checks

```sh
tofu fmt -check -recursive
tofu init -backend=false && tofu validate
tofu test           # tests/*.tftest.hcl, mocked provider, no AWS account needed
tflint
```
