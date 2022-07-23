# Informations about how to use workload identity with terraform and GCP: https://github.com/terraform-google-modules/terraform-google-kubernetes-engine/tree/v12.0.0/modules/workload-identity
# We don't use the module because it's doesn't support well depend_on and we prefer to have the control of this resource. It's also better to understand how it works.

resource "google_service_account" "external_dns" {
  account_id   = "external-dns-${local.cluster_name}"
  display_name = "GCP SA bound to K8S SA external-dns-${local.cluster_name}"
}

resource "kubernetes_service_account" "external_dns" {
  depends_on = [module.gke]

  automount_service_account_token = true
  metadata {
    name      = "external-dns-${local.cluster_name}"
    namespace = "kube-system"
    annotations = {
      "iam.gke.io/gcp-service-account" = google_service_account.external_dns.email
    }
  }
}

resource "google_service_account_iam_member" "external_dns" {
  service_account_id = google_service_account.external_dns.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:${local.google_project}.svc.id.goog[kube-system/${kubernetes_service_account.external_dns.metadata[0].name}]"
}

resource "google_project_iam_member" "external_dns" {
  project = "saa-${terraform.workspace}"
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.external_dns.email}"
}

resource "google_project_iam_member" "external_dns_infra" {
  role    = "roles/dns.admin"
  member  = "serviceAccount:${google_service_account.external_dns.email}"
  project = "saa-${terraform.workspace}"
}

locals {
  common_external_dns_values = {
    "image.tag"               = "0.12.0-debian-11-r9"
    provider                  = "google"
    "nodeSelector.node_pool"  = "system"
    "serviceAccount.create"   = "false"
    "serviceAccount.name"     = kubernetes_service_account.external_dns.metadata[0].name
    "resources.limits.memory" = "64Mi"
    "resources.limits.cpu"    = "20m"
    "policy"                  = "sync" # https://artifacthub.io/packages/helm/bitnami/external-dns?modal=values&path=policy
  }
  external_dns_public_values = {
    "google.project" = "saa-${terraform.workspace}"
    domainFilters    = "{saa-${terraform.workspace}.detect.tn}"
  }
}


resource "helm_release" "external_dns_public" {
  depends_on = [module.gke, kubernetes_service_account.external_dns]

  name       = "external-dns-public"
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "external-dns"
  version    = "6.7.0"

  namespace = "kube-system"

  dynamic "set" {
    for_each = merge(local.common_external_dns_values, local.external_dns_public_values)

    content {
      name  = set.key
      value = set.value
    }
  }
}