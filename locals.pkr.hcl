local "proxmox_user" {
  expression = "root@pam"
  sensitive  = true
}

local "proxmox_pass" {
  expression = "rootpass"
  sensitive  = true
}

local "root_inicial_pass" {
  expression = "rootfirstpass"
  sensitive  = true
}

local "root_pass" {
  expression = "ultimaterootpass"
  sensitive  = true
}

locals {
  timestamp = formatdate("YYYYMMDDhhmm", timestamp())
}