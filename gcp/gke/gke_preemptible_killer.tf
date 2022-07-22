resource "google_project_iam_custom_role" "gke_preemptible_killer" {
  role_id     = "gke_preemptible_killer_gke_app_${replace(terraform.workspace, "-", "_")}"
  title       = "Role for the GKE Preemptible Killer"
  description = "Allow to delete preemptible instance before the maximal 24 hours"
  permissions = ["compute.instances.delete"]
}

module "workload_identity_gke_preemptible_killer" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/workload-identity"
  version = "v21.0.0"

  depends_on = [module.gke]

  project_id = local.google_project

  name                            = "gke-preemptible-killer-${local.cluster_name}"
  namespace                       = "kube-system"
  automount_service_account_token = true

  cluster_name = local.cluster_name

  roles = ["projects/${local.google_project}/roles/gke_preemptible_killer_gke_app_${replace(terraform.workspace, "-", "_")}"]
}

locals {
  gke_preemptible_killer_values = {
    "secret.workloadIdentityServiceAccount" = module.workload_identity_gke_preemptible_killer.k8s_service_account_name
    "serviceAccount.create"                 = false
    "serviceAccount.name"                   = module.workload_identity_gke_preemptible_killer.k8s_service_account_name
    "nodeSelector.node_pool"                = "system"
    #"extraEnv.BLACKLIST_HOURS"              = "11:00 - 13:00\\,18:00 - 21:00"
    #"extraEnv.WHITELIST_HOURS"              = "01:00 - 09:00"
  }
}

resource "helm_release" "gke_preemptible_killer" {
  depends_on = [module.gke, module.workload_identity_gke_preemptible_killer]

  name       = "gke-preemptible-killer"
  repository = "https://helm.estafette.io"
  chart      = "estafette-gke-preemptible-killer"
  version    = "1.3.0"

  namespace = "kube-system"

  dynamic "set" {
    for_each = local.gke_preemptible_killer_values

    content {
      name  = set.key
      value = set.value
    }
  }
}
