module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version = "v22.0.0"

  project_id = local.google_project

  name               = local.cluster_name
  kubernetes_version = var.gke_version
  release_channel    = var.release_channel

  region            = "europe-west1"
  regional          = false
  zones             = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
  network           = "vpc-${terraform.workspace}"
  subnetwork        = google_compute_subnetwork.gke.name
  ip_range_pods     = "${local.cluster_name}-pods"
  ip_range_services = "${local.cluster_name}-services"

  enable_private_nodes       = true
  master_ipv4_cidr_block     = var.master_ipv4_cidr_block
  master_authorized_networks = var.master_authorized_networks

  http_load_balancing             = false
  horizontal_pod_autoscaling      = true
  network_policy                  = true
  enable_vertical_pod_autoscaling = false
  grant_registry_access           = true



  remove_default_node_pool = true
  create_service_account   = true

  node_pools = [
    {
      name               = "system"
      machine_type       = var.system_node_pool_machine_type
      node_locations     = join(",", var.node_locations)
      min_count          = 1
      max_count          = var.max_nodes_count_system
      local_ssd_count    = 0
      disk_size_gb       = var.system_node_pool_disk_size_gb
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = true
      initial_node_count = 1
    },
    {
      name               = "apps"
      machine_type       = var.apps_node_pool_machine_type
      node_locations     = join(",", var.node_locations)
      min_count          = 1
      max_count          = var.max_nodes_count_apps
      local_ssd_count    = 0
      disk_size_gb       = var.apps_node_pool_disk_size_gb
      disk_type          = "pd-standard"
      image_type         = "COS"
      auto_repair        = true
      auto_upgrade       = true
      preemptible        = true
      initial_node_count = 1
    },
  ]

  node_pools_oauth_scopes = {
    all = [
      "https://www.googleapis.com/auth/cloud-platform",
    ]
  }
}