module "networking" {
  source = "../../modules/networking"

  environment = "preprod"

  consul_namespace = module.namespace_consul.namespace
}
