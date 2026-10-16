# Runs with `tofu test` from the module root. The mocked provider means no AWS
# credentials and no cost; switch a run to `command = apply` only when an
# assertion needs computed values such as ARNs.

mock_provider "aws" {}

variables {
  name_prefix = "probes-demo"
}

run "name_prefix_passes_through" {
  command = plan

  assert {
    condition     = output.name == "probes-demo"
    error_message = "name output should equal name_prefix."
  }
}

run "tags_are_merged" {
  command = plan

  variables {
    tags = { Component = "test" }
  }

  assert {
    condition     = output.tags["Component"] == "test"
    error_message = "Caller tags must be kept."
  }
}

run "rejects_invalid_name_prefix" {
  command = plan

  variables {
    name_prefix = "Bad_Name"
  }

  expect_failures = [var.name_prefix]
}
