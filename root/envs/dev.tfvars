# Non-secret values for dev. Committed. Secrets do not go here: use SOPS,
# Vault or TF_VAR_* in the environment.
#
#   tofu plan -var-file=envs/dev.tfvars
account_id = "123456789012"
region     = "eu-central-1"
project    = "REPLACE-ME"

default_tags = {
  Environment = "dev"
}
