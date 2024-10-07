build {
  name = "freebsd"
  sources = [
    "source.proxmox-iso.freebsd-14_1",
  ]

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; env {{ .Vars }} {{ .Path }}"
    scripts = [
      // "scripts/update.sh",
      "scripts/ports.sh",
      "scripts/pkgs.sh",
      "scripts/vim.sh",
      // "scripts/qemu-agent.sh",
      "scripts/security.sh",
      "scripts/cloud-init.sh",
      "scripts/zfs.sh",
    ]
  }

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; env {{ .Vars }} {{ .Path }}"
    inline = [
      "echo \"####### Change root password #######\"",
      "echo '${local.root_pass}' | pw usermod root -h 0",
    ]
  }

  dynamic provisioner {
    for_each = var.users
    labels   = ["shell"]
    content {
      execute_command = "chmod +x {{ .Path }}; env {{ .Vars }} {{ .Path }}"
      inline = [
        "echo \"####### Creating the '${provisioner.key}' user #######\"",
        "echo '${provisioner.value.pass}' | pw useradd -n ${provisioner.key} -b /usr/home -c ${provisioner.key} -G wheel -m -h 0",
      ]
    }
  }

  provisioner "file" {
    source      = "files/motd.txt"
    destination = "/etc/motd.template"
  }

  provisioner "file" {
    source      = "files/cloud.cfg"
    destination = "/usr/local/etc/cloud/cloud.cfg"
  }

  provisioner "file" {
    source      = "files/hotplug.conf"
    destination = "/etc/devd/hotplug.conf"
  }

  provisioner "shell" {
    execute_command = "chmod +x {{ .Path }}; env {{ .Vars }} {{ .Path }}"
    inline = [
      "echo \"####### Delete network configurations #######\"",
      "sed -i '' '/^ifconfig_eth0/d' /etc/rc.conf",
      "sed -i '' '/^defaultrouter/d' /etc/rc.conf"
    ]
  }

  post-processor "manifest" {}

  post-processor "checksum" {
    checksum_types = ["sha256"]
    output         = "${var.vm_name}_{{.ChecksumType}}.checksum"
  }
}