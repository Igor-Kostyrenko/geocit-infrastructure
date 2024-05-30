plugin "terraform" {
    enabled = true
    version = "0.7.0"
    source  = "github.com/terraform-linters/tflint-ruleset-terraform"
}

plugin "google" {
    enabled = true
    version = "0.29.0"
    source  = "github.com/terraform-linters/tflint-ruleset-google"
}

plugin "aws" {
    enabled = true
    version = "0.31.0"
    source  = "github.com/terraform-linters/tflint-ruleset-aws"
}

plugin "azurerm" {
    enabled = true
    version = "0.26.0"
    source  = "github.com/terraform-linters/tflint-ruleset-azurerm"
}