resource "helm_release" "consul" {
  name      = "consul"
  namespace = var.consul_namespace

  chart  = "${path.module}/../../../helm/consul/chart"
  values = ["${file("${path.module}/../../../helm/consul/${var.environment}.values.yaml")}"]
}
