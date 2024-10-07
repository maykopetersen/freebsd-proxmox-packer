proxmox_api_url      = "https://<your.proxmox.ip>:8006/api2/json"
template_name        = "freebsd14.1-packer"
template_description = "FreeBSD 14.1 with Ports installed from GIT builded from Hashcorp Packer"
node                 = "<your-node-name>"
vm_name              = "freebsd-packer"
iso_url              = "https://download.freebsd.org/releases/ISO-IMAGES/14.1/FreeBSD-14.1-RELEASE-amd64-disc1.iso"
iso_file             = "local:iso/FreeBSD-14.1-RELEASE-amd64-disc1.iso"
iso_checksum         = "file:https://download.freebsd.org/releases/ISO-IMAGES/14.1/CHECKSUM.SHA256-FreeBSD-14.1-RELEASE-amd64"
hardening            = true
disk_size            = "15G"
disk_format          = "raw"
zfs_pool             = "zfspool"
network_bridge       = "vmbr1"
network_vlan         = "0"
#network_mac_address  = "00:00:00:00:00:00"
network_static = {
  ip            = ""
  netmask       = ""
  gw            = ""
  dns_server_ip = "1.1.1.1"
  src_domains   = "domain.internal"
}
users = {
  myuserone = { pass = "mypass" }
}