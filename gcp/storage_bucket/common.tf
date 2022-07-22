terraform {
  required_version = ">= 1.0.0"

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 3.85.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 3.85.0"
    }
  }
}

locals {
  google_project = "saa-${terraform.workspace}"
}

provider "google" {
  region  = "europe-west1"
  project = local.google_project
}

provider "google-beta" {
  region  = "europe-west1"
  project = local.google_project
}
