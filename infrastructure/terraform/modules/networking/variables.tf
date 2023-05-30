variable "environment" {
  type        = string
  description = "The environment to deploy to"
}

variable "consul_namespace" {
  type        = string
  description = "The namespace to deploy Consul to"
}
