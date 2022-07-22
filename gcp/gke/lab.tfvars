gke_version                   = "1.21.12-gke.2200"
master_ipv4_cidr_block        = "10.251.128.0/28"
gke_ip_cidr_range             = "10.251.0.0/17"
gke_pods_ip_cidr_range        = "10.252.0.0/16"
gke_services_ip_cidr_range    = "10.253.0.0/16"
node_locations                = ["europe-west1-b", "europe-west1-c"]
system_node_pool_machine_type = "e2-medium"
prometheus_ilb_enabled        = false
grafana_enabled               = false
max_nodes_count_apps          = 2
max_nodes_count_system        = 3