resource "kubernetes_limit_range" "kube_system" {
  metadata {
    name      = "kube-system"
    namespace = "kube-system"
  }
  spec {
    limit {
      type = "Container"
      default = {
        memory = "128Mi"
      }
      default_request = {
        cpu    = "10m"
        memory = "32Mi"
      }
    }
  }
}
