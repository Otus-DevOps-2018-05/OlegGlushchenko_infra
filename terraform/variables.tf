variable project {
  description = "Project ID"
}

variable region {
  description = "Region"
  default     = "europe-west1"
}

variable public_key_path {
  description = "Path to the public key used for ssh access"
}

variable disk_image {
  description = "Disk image"
}

variable private_key_path {
  description = "Path to the private_key for provisioner"
}

variable zone {
  description = "Zone for the project"
  default     = "europe-west1-b"
}

variable vm_count {
  description = "Count of VM"
  default     = 1
}
