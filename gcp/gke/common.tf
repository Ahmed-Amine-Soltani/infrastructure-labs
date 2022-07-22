terraform {
  required_version = ">= 1.0.0"

  backend "gcs" {
    bucket = "saa-tfstate-lab"
    prefix = "infrastructure/google/gke-app"
  }

  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 4.29.0"
    }

    google-beta = {
      source  = "hashicorp/google-beta"
      version = "~> 4.29.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.6.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.12.1"
    }

    kubectl = {
      source  = "gavinbunney/kubectl"
      version = "~> 1.14.0"
    }
  }
}

data "google_client_config" "current" {}

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

provider "kubernetes" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.current.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}

provider "helm" {
  kubernetes {
    host                   = "https://${module.gke.endpoint}"
    token                  = data.google_client_config.current.access_token
    cluster_ca_certificate = base64decode(module.gke.ca_certificate)
  }
}

provider "kubectl" {
  host                   = "https://${module.gke.endpoint}"
  token                  = data.google_client_config.current.access_token
  cluster_ca_certificate = base64decode(module.gke.ca_certificate)
}
