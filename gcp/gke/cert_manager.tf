locals {
  prometheus = {
    "prometheus.enable" = false
  }
  installCRDs = {
    installCRDs = true
  }
  global = {
    "global.podSecurityPolicy.enabled"     = true
    "global.podSecurityPolicy.useAppArmor" = true
  }
  cert_manager_namespace                      = "cert-manager"
  cert_manager_cluster_issuer_staging_name    = "letsencrypt-staging"
  cert_manager_cluster_issuer_production_name = "letsencrypt-prod"
  cert_manager_certificate_name               = "saa-certs"
  certificate_namespace                       = "default"
  certificate_home_hostname                   = "saa.detect.tn"


}


resource "google_service_account" "cert_manager" {
  depends_on   = [module.gke]
  account_id   = "gke-cert-manager"
  display_name = "GCP SA to be able to use DNS resolution with cert manager"
}

resource "google_service_account_iam_member" "cert_manager" {
  depends_on         = [module.gke, google_service_account.cert_manager]
  service_account_id = google_service_account.cert_manager.name
  role               = "roles/iam.workloadIdentityUser"
  member             = "serviceAccount:saa-lab.svc.id.goog[${local.cert_manager_namespace}/${google_service_account.cert_manager.account_id}]"
}

resource "google_project_iam_member" "cert_manager" {
  depends_on = [module.gke, google_service_account.cert_manager, google_service_account_iam_member.cert_manager]
  project    = "saa-${terraform.workspace}"
  role       = "roles/dns.admin"
  member     = "serviceAccount:${google_service_account.cert_manager.email}"
}

resource "helm_release" "cert_manager" {
  depends_on = [module.gke, google_service_account.cert_manager, google_service_account_iam_member.cert_manager]

  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  version    = "v1.8.2"

  namespace        = "cert-manager"
  create_namespace = true

  dynamic "set" {
    for_each = merge(local.prometheus, local.installCRDs, local.global)

    content {
      name  = set.key
      value = set.value
    }
  }

  set {
    name  = "serviceAccount.name"
    value = google_service_account.cert_manager.account_id
  }

  set {
    name  = "serviceAccount.annotations.iam\\.gke\\.io/gcp-service-account"
    value = google_service_account.cert_manager.email
  }

}

resource "kubectl_manifest" "cert_manager_cluster_issuer_staging" {
  depends_on = [helm_release.cert_manager]
  yaml_body = templatefile(
    "${path.root}/templates/ClusterIssuer_Staging.yaml.tpl",
    {
      name        = local.cert_manager_cluster_issuer_staging_name
      email       = "gcp9909.1@gmail.com"
      gcp_project = "saa-lab"
    }
  )
}

resource "kubectl_manifest" "cert_manager_cluster_issuer_production" {
  depends_on = [helm_release.cert_manager]
  yaml_body = templatefile(
    "${path.root}/templates/ClusterIssuer_Production.yaml.tpl",
    {
      name        = local.cert_manager_cluster_issuer_production_name
      email       = "gcp9909.1@gmail.com"
      gcp_project = "saa-lab"
    }
  )
}

# We need to wait a few to make sure the custom resources full register
#resource "helm_release" "cert_manager" {
#depends_on = [
#helm_release.cert_manager
#]

#create_duration = "30s"
#}