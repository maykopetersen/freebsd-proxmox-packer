
# freebsd-proxmox-packer

FreeBSD installation on Proxmox hypervisor using Hashicorp Packer. 
This template has [cloud-init support](https://pve.proxmox.com/wiki/Cloud-Init_FAQ).

<img src="http://img.shields.io/static/v1?label=License&message=BSD&color=red&style=for-the-badge"/>

## Prerequisites
- [Proxmox VE hypervisor](https://www.proxmox.com/en/proxmox-virtual-environment/overview) - where the template will be stored in.
- [Hashicorp Packer](https://www.packer.io/).
- [xorriso](https://www.gnu.org/software/xorriso/) - because it will be necessary to use [`additional_iso_files`](https://developer.hashicorp.com/packer/integrations/hashicorp/proxmox/latest/components/builder/iso#optional).

## How to create a VM template?

1. Clone this repository:
```sh
$ git clone https://github.com/maykopetersen/freebsd-proxmox-packer.git
```
2. Install all the missing plugins required in a Packer config:
```sh
$ cd freebsd-proxmox-packer
$ packer init .
```
3. Change the variable's values (see more in the next topics).
4. Build the template:
```sh
$ packer build .
```

### [Variables](packer.auto.pkrvars.hcl)

The most important values that you MUST change are:
- `proxmox_api_url`: refers to `proxmox_url` argument from [`Proxmox ISO`](https://developer.hashicorp.com/packer/integrations/hashicorp/proxmox/latest/components/builder/iso). You can remove this argument and use `PROXMOX_URL` environment variable.
- `node`: refers to `node` argument.
- `zfs_pool`: refers to `storage_pool` and `cloud_init_storage_pool` arguments. Usually is `local-lvm`.
- `network_bridge`: refers to `network_adapters{bridge}` argument. 
- `network_vlan`: refers to `network_adapters{vlan_tag}` argument. The network vlan tag. 
- `network_mac_address`: refers to `network_adapters{mac_address}` argument. If your DHCP server assigns addresses based on MAC address, you must configure this argument.
- `network_static {}` map: This map contains `IP`, `netmask` and `gw` if you use static address. If you use DHCP, these values must be `""`. The `dns_server_ip` is the `nameserver` value in `/etc/resolv.conf`; the `src_domains` is the `search` value in `/etc/resolv.conf` (both are necessary to install `qemu-guest-agent` package).
  - [`optional(_type_)` **doesn't** work in Packer like Terraform](https://github.com/hashicorp/packer/issues/13098). Because of this, these arguments MUST exist.
- `users {}` map: Map with users and their passwords.

### [Local Variables](locals.pkr.hcl)
You must change all values in this file.
- `proxmox_user`: The user with access to create templates in your Proxmox cluster. You can remove this argument and use `PROXMOX_USERNAME` environment variable.
> [!IMPORTANT] 
> The user must have the [following privileges](https://pve.proxmox.com/wiki/User_Management#pveum_permission_management):
>  - SDN.Use
>  - VM.Allocate
>  - VM.Audit
>  - VM.Config.CDROM
>  - VM.Config.CPU
>  - VM.Config.Cloudinit
>  - VM.Config.Disk
>  - VM.Config.HWType
>  - VM.Config.Memory
>  - VM.Config.Network
>  - VM.Config.Options
>  - VM.Console
>  - VM.Monitor
>  - VM.PowerMgmt
>  - Datastore.AllocateSpace
>  - Datastore.AllocateTemplate
>  - Datastore.Audit
>  - Datastore.Allocate
- `proxmox_pass`: User's pass from `proxmox_user`. You can remove this argument and use `PROXMOX_PASSWORD` environment variable.
- `root_inicial_pass`: The initial root pass used by Packer to SSH the FreeBSD.
- `root_pass`: The root pass stored in final VM template.

As these arguments are local variables, they can be defined by [vault functions](https://developer.hashicorp.com/packer/docs/templates/hcl_templates/functions/contextual/vault). 

## How to use the VM template?

1. Clone the template to a VM using Proxmox UI.
2. Configure Cloud-init options, putting your public key in `SSH Public Key` field.
3. Do other configurations (HD, RAM, CPUs, Network devices, etc).
4. Start your VM.
5. Access your VM from your machine:
```
$ ssh -i <your-private-key-file> freebsd@<VM_IP>

```
6. Become `root`:
```
freebsd@machine:~ % sudo su -
root@machine:~ #
```

## About `qemu-guest-agent` installation in bsdinstaller

It's important to install the agent in the early process because if it is disabled, you will see the following error in a build debug process:
```
[DEBUG] Error getting SSH address: 500 QEMU guest agent is not running
```
Packer needs to know the VM's IP address to connect it using SSH. Packer does this using `qemu-guest-agent`.

If you don't want to install any package or if you don't want to bootstrap `pkg` from a remote repository in the `bsdinstaller` process, you must configure `ssh_host` in `source` block with a fixed IP (defined by `var.network_static`) used by this template.

## About FreeBSD installation file types

You can't use the [`bootonly`](https://docs.freebsd.org/en/books/handbook/bsdinstall/#bsdinstall-installation-media) FreeBSD image in Packer like you could do with a Debian `netinstall` image, for example. This occurs because FreeBSD first needs to install the OS base before performing any operation. The `bootonly` image doesn't contain the OS base, so you have to go online and download it. Since the DNS configuration is done **AFTER** the OS base has been installed, it is impossible to resolve any external names. Even if you put the IP in the `BSDINSTALL_DISTSITE` field as instructed in the [`bsdinstall` manual](https://man.freebsd.org/cgi/man.cgi?query=bsdinstall) and get an IP from your DHCP server with internet access, it won't work.

## [License](LICENSE)

[Simplified BSD License](https://www.tldrlegal.com/license/bsd-2-clause-license-freebsd).
Copyright (c) 2024-2024, Mayko Petersen <maykopetersen@tic.ufrj.br>.

## Acknowledgements
| [<img src="https://avatars.githubusercontent.com/u/15877106?v=4" width=100 > <br> <sub> Tsiry Sandratraina </sub>](https://github.com/tsirysndr) |
| :---: |

help me with some ideas from [this repository](https://github.com/tsirysndr/packer-FreeBSD).