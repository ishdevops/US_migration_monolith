terraform {
  backend "remote" {
    hostname = "app.terraform.io"
    organization = "SalaryFinance"

    workspaces {
      name = "US_migration_monolith"
    }
  }
}
