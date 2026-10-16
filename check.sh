#!/usr/bin/env bash
# Checks the skeletons themselves: formatting, validation, lint, module tests.
# Works without AWS credentials: init runs with -backend=false and the module
# tests use a mocked provider.
set -euo pipefail
cd "$(dirname "$0")"

# init leaves .terraform/ and lock files behind; a skeleton must not carry them,
# because -from-module from a local path copies them into the new project.
cleanup() { find . -name .terraform -type d -prune -exec rm -rf {} + ; find . -name .terraform.lock.hcl -delete; }
trap cleanup EXIT

tofu fmt -check -recursive -diff .

for dir in module module/examples/minimal root terragrunt/modules/example; do
  echo "== $dir"
  (cd "$dir" && tofu init -backend=false -input=false >/dev/null && tofu validate -no-color)
done

echo "== module tests"
(cd module && tofu test -no-color)

if command -v tflint >/dev/null; then
  for dir in module root; do
    echo "== tflint $dir"
    (cd "$dir" && tflint --init >/dev/null && tflint)
  done
fi

if command -v terragrunt >/dev/null; then
  echo "== terragrunt hcl fmt"
  (cd terragrunt && terragrunt hcl fmt --check)
fi
