variable "proxmox_api_url" {
  description = "URL to the Proxmox API."
  type        = string
  sensitive   = false
  validation {
    condition     = substr(var.proxmox_api_url, 0, 8) == "https://" && substr(var.proxmox_api_url, -9, -1) == "api2/json"
    error_message = "The URL must be \"https://<IP.OF.HYPER.VISOR>:<PORT>/api2/json\"."
  }
}

variable "template_name" {
  description = "The template name."
  type        = string
}

variable "template_description" {
  description = "The template description which is shown in the 'Notes' field, in 'Summary'."
  type        = string
}

variable "node" {
  description = "The node name where the template will be created and stored in."
  type        = string
}

variable "vm_name" {
  description = "VM's name used until it be converted in template."
  type        = string
}

variable "iso_url" {
  description = "The FreeBSD bootonly ISO URL."
  type        = string
}

variable "iso_file" {
  description = "Storage where will be stored the SO's ISO (this storage needs accept 'ISO image' content type)."
  type        = string
}

variable "iso_checksum" {
  description = "ISO checksum."
  type        = string
}

variable "hardening" {
  description = "If Hardening Security Options will be configured or not."
  type        = bool
}

variable "disk_size" {
  description = "VM disk size."
  type        = string
}

variable "disk_format" {
  description = "Format of the file backing the disk."
  type        = string
}

variable "zfs_pool" {
  description = "ZFS Pool that exists in the node (it will be used to configure 'storage_pool' in 'disk' and 'cloud-init)."
  type        = string
}

variable "network_bridge" {
  description = "Which Proxmox bridge to attach the adapter to. Must be the interface where the 'network_vlan' passes on."
  type        = string
  default     = "vmbr0"
}

variable "network_vlan" {
  description = "VM's vlan tag"
  type        = string
  default     = ""
}

variable "network_mac_address" {
  description = "MAC address used by the VM to get an IP via DHCP."
  type        = string
  default     = "repeatable"
}

variable "network_static" {
  description = "Network configurations."
  type = object({
    ip            = string
    netmask       = string
    gw            = string
    dns_server_ip = string
    src_domains   = string

  })
  default = {
    ip            = ""
    netmask       = ""
    gw            = ""
    dns_server_ip = "1.1.1.1"
    src_domains   = ""
  }
}

variable "users" {
  description = "The users to be added. These users are included in 'wheel' group."
  type = map(object({
    pass = string
  }))
}