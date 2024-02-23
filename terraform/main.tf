terraform {
  required_providers {
    commercetools = {
      source = "labd/commercetools"
    }
    google = {
      source  = "hashicorp/google"
      version = ">= 4.34.0"
    }
  }
}

provider "commercetools" {
  client_id     = var.ct_client_id
  client_secret = var.ct_client_secret
  project_key   = var.ct_project_key
  scopes        = var.ct_scopes
  api_url       = var.ct_api_url
  token_url     = var.ct_auth_url
}

provider "google" {
  project     = var.gcp_project_id
  region      = var.gcp_region
}