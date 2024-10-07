packer {
  required_plugins {
    name = {
      version = "~> 1.1.8"
      source  = "github.com/hashicorp/proxmox"
    }
  }
}

source "proxmox-iso" "freebsd-14_1" {
  template_description = var.template_description

  # Proxmox Connection Settings
  proxmox_url              = var.proxmox_api_url
  username                 = local.proxmox_user
  password                 = local.proxmox_pass
  insecure_skip_tls_verify = true

  # Used to store installerconfig
  additional_iso_files {
    cd_files = [
      "./additional_files/etc/installerconfig",
    ]
    cd_label         = "cidata"
    iso_storage_pool = "local"
    unmount          = true
  }

  /*---------------------------------
      VM General Settings: like GUI!
    ---------------------------------*/
  node             = var.node
  vm_name          = "${var.vm_name}-${local.timestamp}"
  iso_url          = var.iso_url
  iso_storage_pool = "local"
  iso_checksum     = var.iso_checksum
  os               = "l26"
  scsi_controller  = "virtio-scsi-single"
  qemu_agent       = true

  disks {
    disk_size    = var.disk_size
    format       = var.disk_format
    storage_pool = var.zfs_pool
    type         = var.disk_format == "qcow2" ? "scsi" : "virtio"
    discard      = var.disk_format == "qcow2" ? true : false
    ssd          = var.disk_format == "qcow2" ? true : false
    io_thread    = true
  }

  sockets            = "2"
  cores              = "2"
  numa               = true
  cpu_type           = "x86-64-v2"
  memory             = "2048"
  ballooning_minimum = "1024"

  network_adapters {
    mac_address = var.network_mac_address
    model       = "virtio"
    bridge      = var.network_bridge
    vlan_tag    = var.network_vlan
    firewall    = false
  }

  unmount_iso = true

  // ssh_host     = var.network_static.ip
  ssh_username = "root"
  ssh_password = local.root_inicial_pass
  ssh_timeout  = "50m"

  # This is done AFTER all builds run:
  cloud_init              = true
  cloud_init_storage_pool = var.zfs_pool

  http_directory = "./"
  boot_wait      = "10s"
  boot_command = [
    "<esc><wait>",
    "boot -s<enter>",
    "<wait25s>",
    "/bin/sh<enter><wait>",
    "mdmfs -s 100m md /tmp<enter><wait>",
    "mount_cd9660 /dev/cd1 /mnt/<enter>",
    "export HOSTNAME=${var.vm_name}<enter>",
    "export ROOTPASS=${local.root_inicial_pass}<enter>",
    "export IP=${var.network_static.ip}<enter>",
    "export MASK=${var.network_static.netmask}<enter>",
    "export GW=${var.network_static.gw}<enter>",
    "export SRC=${var.network_static.src_domains}<enter>",
    "export NS=${var.network_static.dns_server_ip}<enter>",
    "export HARDENING=${lower(var.hardening)}<enter>",
    "bsdinstall script /mnt/installerconfig<enter>",
  ]
}