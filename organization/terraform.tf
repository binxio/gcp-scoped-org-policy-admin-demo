terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "4.27.0"
    }
    random = {
      source = "hashicorp/random"
      version = "3.3.2"
    }
  }
}

provider "google" { 
}

provider "random" {
}
