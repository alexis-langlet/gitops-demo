module "networking" {
  source = "../../modules/networking"

  environment = "prod"

  consul_namespace = module.namespace_consul.namespace
}
