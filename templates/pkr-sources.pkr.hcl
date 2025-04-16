locals {
  # Source block provider specific

  # virtualbox-iso
  vbox_gfx_controller = var.vbox_gfx_controller == null ? (
    var.is_windows ? "vboxsvga" : "vmsvga"
  ) : var.vbox_gfx_controller
  vbox_gfx_vram_size = var.vbox_gfx_controller == null ? (
    var.is_windows ? 128 : 33
  ) : var.vbox_gfx_vram_size
  vbox_guest_additions_mode = var.vbox_guest_additions_mode == null ? (
    var.is_windows ? "attach" : "upload"
  ) : var.vbox_guest_additions_mode


  # Source block common
  default_boot_wait = var.default_boot_wait == null ? (
    var.is_windows ? "60s" : (
      var.os_name == "macos" ? "8m" : "5s"
    )
  ) : var.default_boot_wait
  cd_files = var.cd_files == null ? (
    var.is_windows ? (
      var.hyperv_generation == 2 ? [
        "${path.root}/win_answer_files/${var.os_version}/hyperv-gen2/Autounattend.xml",
        ] : (
        var.os_arch == "x86_64" ? [
          "${path.root}/win_answer_files/${var.os_version}/Autounattend.xml",
          ] : [
          "${path.root}/win_answer_files/${var.os_version}/arm64/Autounattend.xml",
        ]
      )
    ) : null
  ) : var.cd_files
  communicator = var.communicator == null ? (
    var.is_windows ? "winrm" : "ssh"
  ) : var.communicator
  floppy_files = var.floppy_files == null ? (
    var.is_windows ? (
      var.os_arch == "x86_64" ? [
        "${path.root}/win_answer_files/${var.os_version}/Autounattend.xml",
        ] : [
        "${path.root}/win_answer_files/${var.os_version}/arm64/Autounattend.xml",
      ]
    ) : null
  ) : var.floppy_files
  http_directory = var.http_directory == null ? "${path.root}/http" : var.http_directory
  memory = var.memory == null ? (
    var.is_windows || var.os_name == "macos" ? 4096 : 2048
  ) : var.memory
  output_directory = var.output_directory == null ? "${path.root}/../builds/build_files/packer-${var.os_name}-${var.os_version}-${var.os_arch}" : var.output_directory
  shutdown_command = var.shutdown_command == null ? (
    var.is_windows ? "shutdown /s /t 10 /f /d p:4:1 /c \"Packer Shutdown\"" : (
      var.os_name == "macos" ? "echo 'vagrant' | sudo -S shutdown -h now" : (
        var.os_name == "freebsd" ? "echo 'vagrant' | su -m root -c 'shutdown -p now'" : "echo 'vagrant' | sudo -S /sbin/halt -h -p"
      )
    )
  ) : var.shutdown_command
  vm_name = var.vm_name == null ? (
    var.os_arch == "x86_64" ? "${var.os_name}-${var.os_version}-amd64" : "${var.os_name}-${var.os_version}-${var.os_arch}"
  ) : var.vm_name
}

# https://www.packer.io/docs/templates/hcl_templates/blocks/source
# Virtualbox source block
source "virtualbox-iso" "vm" {
  # Virtualbox specific options
  #firmware                  = "efi"
  gfx_controller            = local.vbox_gfx_controller
  gfx_vram_size             = local.vbox_gfx_vram_size
  guest_additions_path      = var.vbox_guest_additions_path
  guest_additions_mode      = local.vbox_guest_additions_mode
  guest_additions_interface = var.vbox_guest_additions_interface
  guest_os_type             = var.vbox_guest_os_type
  hard_drive_interface      = var.vbox_hard_drive_interface
  iso_interface             = var.vbox_iso_interface
  vboxmanage                = var.vboxmanage
  virtualbox_version_file   = var.virtualbox_version_file
  # Source block common options
  boot_command     = var.boot_command
  boot_wait        = var.vbox_boot_wait == null ? local.default_boot_wait : var.vbox_boot_wait
  cpus             = var.cpus
  communicator     = local.communicator
  disk_size        = var.disk_size
  floppy_files     = local.floppy_files
  headless         = var.headless
  http_directory   = local.http_directory
  iso_checksum     = var.iso_checksum
  iso_url          = var.iso_url
  memory           = local.memory
  output_directory = "${local.output_directory}-virtualbox"
  shutdown_command = local.shutdown_command
  shutdown_timeout = var.shutdown_timeout
  ssh_password     = var.ssh_password
  ssh_port         = var.ssh_port
  ssh_timeout      = var.ssh_timeout
  ssh_username     = var.ssh_username
  winrm_password   = var.winrm_password
  winrm_timeout    = var.winrm_timeout
  winrm_username   = var.winrm_username
  vm_name          = local.vm_name
  # nested_virt      = flase
  # rtc_time_base = local
  # gfx_accelerate_3d = true
}
source "virtualbox-ovf" "vm" {
  # Virtualbox specific options
  guest_additions_path    = var.vbox_guest_additions_path
  source_path             = var.vbox_source_path
  checksum                = var.vbox_checksum
  vboxmanage              = var.vboxmanage
  virtualbox_version_file = var.virtualbox_version_file
  # Source block common options
  communicator     = local.communicator
  headless         = var.headless
  output_directory = "${local.output_directory}-virtualbox-ovf"
  shutdown_command = local.shutdown_command
  shutdown_timeout = var.shutdown_timeout
  ssh_password     = var.ssh_password
  ssh_port         = var.ssh_port
  ssh_timeout      = var.ssh_timeout
  ssh_username     = var.ssh_username
  vm_name          = local.vm_name
}

# source "virtualbox-iso" "autogenerated_1" {
#   boot_command            = ["<esc><esc><esc>", "<enter><wait>", "/casper/vmlinuz ", "initrd=/casper/initrd ", "autoinstall ", "<enter>"]
#   boot_wait               = "5s"
#   cd_files                = ["./http/meta-data", "./http/user-data"]
#   cd_label                = "cidata"
#   cpus                    = "1"
#   disk_size               = "40960"
#   gfx_accelerate_3d       = true
#   gfx_controller          = "vmsvga"
#   gfx_vram_size           = "128"
#   guest_additions_path    = "VBoxGuestAdditions_{{ .Version }}.iso"
#   guest_os_type           = "Ubuntu_64"
#   hard_drive_interface    = "sata"
#   http_directory          = "{{pwd}}/http"
#   iso_checksum            = "d6dab0c3a657988501b4bd76f1297c053df710e06e0c3aece60dead24f270b4d"
#   iso_url                 = "D:\\workFiles\\VirtualFiles\\isofiles\\ubuntu-24.04.2-live-server-amd64.iso"
#   memory                  = "2048"
#   nested_virt             = true
#   output_directory        = "../builds/packer-ubuntu-24.04.02-x86_64-virtualbox"
#   rtc_time_base           = "local"
#   shutdown_command        = "echo Xjh@911128 | sudo -S shutdown -P now"
#   ssh_handshake_attempts  = "2000"
#   ssh_password            = "Xjh@911128"
#   ssh_port                = 22
#   ssh_timeout             = "60m"
#   ssh_username            = "echoxu"
#   vboxmanage              = [["modifyvm", "{{ .Name }}", "--vrde", "off"], ["modifyvm", "{{ .Name }}", "--recording", "off"], ["modifyvm", "{{ .Name }}", "--clipboard", "bidirectional"], ["modifyvm", "{{ .Name }}", "--draganddrop", "bidirectional"], ["storagectl", "{{ .Name }}", "--name", "SATA Controller", "--hostiocache", "on"], ["storageattach", "{{ .Name }}", "--storagectl", "SATA Controller", "--port", "0", "--nonrotational", "on"]]
#   virtualbox_version_file = ".vbox_version"
#   vm_name                 = "ubuntu-2404.1-x86_64"
# }


# source "docker" "vm" {

# }
