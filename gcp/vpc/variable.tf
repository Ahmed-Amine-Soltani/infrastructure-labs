variable subnet_ip_cidr_range {
  type        = string
  description = "IP CIDR for the first subnet of the VPC"
}

variable "vpc_description" {
  type        = string
  description = "Description of the VPC"
  default     = ""
}

variable subnet_secondary_ip_range {
  type        = list(map(string))
  description = "List of map to add secondary ip range to the subnet"
  default     = []
}

variable nat_ip_allocate_option {
  type        = string
  default     = "AUTO_ONLY"
  description = "Nat IP allocate option. Can be AUTO_ONLY or MANUAL_ONLY"
}

variable nat_ips {
  type        = list(string)
  default     = []
  description = "List of ips for the nat gateway. Only if nat_ip_allocate_option is MANUAL_ONLY"
}
