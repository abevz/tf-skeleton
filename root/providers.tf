provider "aws" {
  region = var.region

  # A wrong-account apply is the one mistake that is genuinely expensive to
  # undo. Fail before touching anything instead.
  allowed_account_ids = [var.account_id]

  default_tags {
    tags = var.default_tags
  }
}
