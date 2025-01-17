terraform {
  required_providers {
    vault = {
      source  = "hashicorp/vault"
      version = "3.14.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "2.9.0"
    }

    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.19.0"
    }
  }
}

variable "vault_address" {
  type        = string
  description = "The address of the Vault server"
  default     = "https://vault.gitops-demo.a-gomez.fr"
}

variable "vault_token" {
  type        = string
  sensitive   = true
  description = "The token to authenticate to the Vault server"
}

provider "vault" {
  address = var.vault_address
  token   = var.vault_token
}

variable "kubeconfig_path" {
  type        = string
  description = "Path to kubeconfig file"
  default     = "~/.kube/gitops-demo"
}

variable "kubeconfig_context" {
  type        = string
  description = "Context to use in kubeconfig"
  default     = "gitops-demo-preprod"
}

provider "kubernetes" {
  config_path    = var.kubeconfig_path
  config_context = var.kubeconfig_context
}

provider "helm" {
  kubernetes {
    config_path    = var.kubeconfig_path
    config_context = var.kubeconfig_context
  }
}
