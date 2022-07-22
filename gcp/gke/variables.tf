locals {
  cluster_name = "gke-app-${terraform.workspace}"
}

variable "gke_version" {
  type        = string
  default     = "1.19.12-gke.2101"
  description = "Version of the GKE cluster"
}

variable "release_channel" {
  type        = string
  default     = "STABLE"
  description = "The release channel of this cluster. Accepted values are UNSPECIFIED, RAPID, REGULAR and STABLE."
}


variable "node_locations" {
  type        = list(any)
  default     = ["europe-west1-b", "europe-west1-c", "europe-west1-d"]
  description = "Locations of the nodes"
}

variable "system_node_pool_machine_type" {
  type        = string
  default     = "n2-highcpu-4"
  description = "Type of the instance if the node pool system"
}

variable "system_node_pool_disk_size_gb" {
  type        = number
  default     = 30
  description = "Disk size in gb of instance in the system node pool"
}

variable "apps_node_pool_machine_type" {
  type        = string
  default     = "n2-highcpu-4"
  description = "Type of the instance if the node pool apps"
}

variable "apps_node_pool_disk_size_gb" {
  type        = number
  default     = 100
  description = "Disk size in gb of instance in the apps node pool"
}


variable "gke_ip_cidr_range" {
  type        = string
  description = "CIDR block for the GKE cluster."
}

variable "gke_pods_ip_cidr_range" {
  type        = string
  description = "CIDR block for the pods ips"
}

variable "gke_services_ip_cidr_range" {
  type        = string
  description = "CIDR block for the services ips"
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "CIDR block for the master nodes. Must be /28"
}

variable "master_authorized_networks" {
  type = list(map(string))
  default = [
    {
      cidr_block   = "0.0.0.0/0",
      display_name = "internet"
    }
  ]
  description = "List of authorized networks to access to the master nodes"
}

variable "cluster_autoscaling_max_cpu_cores" {
  type        = number
  default     = 32
  description = "Maximal CPU cores for the cluster autoscaling"
}

variable "cluster_autoscaling_max_memory_gb" {
  type        = number
  default     = 32
  description = "Maximal memory in Gb for the cluster autoscaling"
}

variable "max_nodes_count_apps" {
  type        = number
  default     = 2
  description = "Maximal number of nodes in the apps pool"
}

variable "max_nodes_count_system" {
  type        = number
  default     = 2
  description = "Maximal number of nodes in the system pool"
}

variable "slack_api_url" {
  type        = string
  default     = ""
  description = "URL of Slack to send alerts with prometheus"
}

variable "slack_channel" {
  type        = string
  default     = "#platform-errors"
  description = "Channel where to send alerts"
}

variable "pagerduty_service_key" {
  type        = string
  default     = "8e0a320708a844e585b896a5fdd54591"
  description = "pagerduty service where to send alerts"
}


variable "prometheus_replicas" {
  type        = number
  default     = 1
  description = "Number of Prometheus replicas"
}

variable "prometheus_alert_over_commit_enabled" {
  type        = bool
  default     = true
  description = "To enable Prometheus alert on over commit cpu and memory"
}

variable "komodor_integration_enabled" {
  type        = bool
  default     = false
  description = "If we want to enable the komodor integration with Alert Manager"
}

variable "komodor_webhook_url" {
  type        = string
  default     = "https://app.komodor.com/prometheus-alert-manager/event/7090ee15-eee1-4f37-b8b7-1300980459e3"
  description = "Url of the webhook for Alert Manager for the komodor integration"
}

variable "filebeat_resources_requests" {
  type = map(string)
  default = {
    cpu    = "100m"
    memory = "64Mi"
  }
}

variable "filebeat_resources_limits" {
  type = map(string)
  default = {
    cpu    = "1"
    memory = "256Mi"
  }
}

variable "additional_scrape_configs" {
  type = list(object({
    job_name        = string,
    metrics_path    = string,
    target          = list(string),
    scrape_interval = string
  }))
  description = "additional scrape configs for prometheus"
  default     = []
}

variable "prometheus_ilb_enabled" {
  type        = bool
  default     = false
  description = "this variable is used to change the prometheus service type from ClusterIP to Internal Loadbalancer"
}

variable "grafana_enabled" {
  type        = bool
  default     = false
  description = "this variable is used to deploy grafana if it is true"
}

variable "nfs_server_provisioner_enabled" {
  type        = bool
  default     = false
  description = "If we want to install NFS server provisioner"
}

variable "cluster_overprovisioner_enabled" {
  type        = bool
  default     = false
  description = "If we want to install the cluster overprovisioner"
}

variable "cluster_overprovisioner_config" {
  type = object({
    apps = object({
      replicas     = number
      cpu_limit    = string
      memory_limit = string
    }),
    system = object({
      replicas     = number
      cpu_limit    = string
      memory_limit = string
    }),
  })
  default = {
    apps = {
      replicas     = 2
      cpu_limit    = "1000m"
      memory_limit = "1000Mi"
    }
    system = {
      replicas     = 2
      cpu_limit    = "1000m"
      memory_limit = "1000Mi"
    }
  }
  description = "Configuration for the cluster overprovisioner"
}
