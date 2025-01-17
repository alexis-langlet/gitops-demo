data "kubernetes_namespace_v1" "kube-prometheus-stack" {
  metadata {
    name = var.kube-prometheus-stack-namespace
  }
}

data "vault_kv_secret_v2" "grafana_admin-password" {
  name  = "${var.environment}/monitoring/grafana/admin-password"
  mount = "kvv2"
}

resource "helm_release" "kube-prometheus-stack" {
  name      = "kube-prometheus-stack"
  namespace = data.kubernetes_namespace_v1.kube-prometheus-stack.metadata[0].name

  chart  = "${path.module}/../../../../helm/kube-prometheus-stack/chart"
  values = ["${file("${path.module}/../../../../helm/kube-prometheus-stack/${var.environment}.values.yaml")}"]

  set_sensitive {
    name  = "grafana.adminPassword"
    value = data.vault_kv_secret_v2.grafana_admin-password.data["password"]
  }
}

data "kubernetes_service_v1" "grafana" {
  metadata {
    name      = "kube-prometheus-stack-grafana"
    namespace = data.kubernetes_namespace_v1.kube-prometheus-stack.metadata[0].name
  }

  depends_on = [
    helm_release.kube-prometheus-stack
  ]
}

resource "kubernetes_ingress_v1" "grafana" {
  metadata {
    name      = "grafana"
    namespace = data.kubernetes_namespace_v1.kube-prometheus-stack.metadata[0].name

    annotations = {
      "kubernetes.io/ingress.class"    = "nginx"
      "cert-manager.io/cluster-issuer" = "letsencrypt-issuer"
    }
  }

  spec {
    tls {
      hosts       = ["grafana.${var.domain}"]
      secret_name = "grafana-tls"
    }
    rule {
      host = "grafana.${var.domain}"

      http {
        path {
          path = "/"

          backend {
            service {
              name = data.kubernetes_service_v1.grafana.metadata[0].name
              port {
                number = data.kubernetes_service_v1.grafana.spec[0].port[0].port
              }
            }
          }
        }
      }
    }
  }
}
