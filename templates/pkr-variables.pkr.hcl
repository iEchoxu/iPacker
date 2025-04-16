# General variables
variable "os_name" {
  type        = string
  description = "OS Brand Name"
}
variable "os_version" {
  type        = string
  description = "OS version number"
}
variable "os_arch" {
  type = string
  validation {
    condition     = var.os_arch == "x86_64" || var.os_arch == "aarch64"
    error_message = "The OS architecture type should be either x86_64 or aarch64."
  }
  description = "OS architecture type, x86_64 or aarch64"
}
variable "is_windows" {
  type        = bool
  default     = false
  description = "Determines to set setting for Windows or Linux"
}
variable "http_proxy" {
  type        = string
  default     = env("http_proxy")
  description = "Http proxy url to connect to the internet"
}
variable "https_proxy" {
  type        = string
  default     = env("https_proxy")
  description = "Https proxy url to connect to the internet"
}
variable "no_proxy" {
  type        = string
  default     = env("no_proxy")
  description = "No Proxy"
}
variable "sources_enabled" {
  type = list(string)
  default = [
    "source.virtualbox-iso.vm",
    # "source.docker.vm",
  ]
  description = "Build Sources to use for building vagrant boxes"
}

# Source block provider specific variables
# virtualbox-iso
variable "vbox_boot_wait" {
  type    = string
  default = null
}
variable "vbox_gfx_controller" {
  type    = string
  default = null
}
variable "vbox_gfx_vram_size" {
  type    = number
  default = null
}
variable "vbox_guest_additions_interface" {
  type    = string
  default = "sata"
}
variable "vbox_guest_additions_mode" {
  type    = string
  default = null
}
variable "vbox_guest_additions_path" {
  type    = string
  default = "VBoxGuestAdditions_{{ .Version }}.iso"
}
variable "vbox_guest_os_type" {
  type        = string
  default     = null
  description = "OS type for virtualization optimization"
}
variable "vbox_hard_drive_interface" {
  type    = string
  default = "sata"
}
variable "vbox_iso_interface" {
  type    = string
  default = "sata"
}
variable "vboxmanage" {
  type = list(list(string))
  default = [
    [
      "modifyvm",
      "{{.Name}}",
      "--audio",
      "none",
      "--nat-localhostreachable1",
      "on",
    ],
    [
      "modifyvm",
      "{{.Name}}",
      "--vrde",
      "off"
    ],
    [
      "modifyvm",
      "{{.Name}}",
      "--recording",
      "off"
    ],
    [
      "modifyvm",
      "{{.Name}}",
      "--clipboard",
      "bidirectional"
    ],
    [
      "modifyvm",
      "{{.Name}}",
      "--draganddrop",
      "bidirectional"
    ],
    [
      "storagectl",
      "{{.Name}}",
      "--name",
      "SATA Controller",
      "--hostiocache",
      "on"
    ],
    [
      "storageattach",
      "{{.Name}}",
      "--storagectl",
      "SATA Controller",
      "--port",
      "0",
      "--nonrotational",
      "on"
    ],
  ]
}
variable "virtualbox_version_file" {
  type    = string
  default = ".vbox_version"
}

# virtualbox-ovf
variable "vbox_source_path" {
  type        = string
  default     = null
  description = "Path to the OVA/OVF file"
}
variable "vbox_checksum" {
  type        = string
  default     = null
  description = "Checksum of the OVA/OVF file"
}


# Source block common variables
variable "boot_command" {
  type        = list(string)
  default     = null
  description = "Commands to pass to gui session to initiate automated install"
}
variable "default_boot_wait" {
  type    = string
  default = null
}
variable "cd_files" {
  type    = list(string)
  default = null
}
variable "cpus" {
  type    = number
  default = 2
}
variable "communicator" {
  type    = string
  default = null
}
variable "disk_size" {
  type    = number
  default = 65536
}
variable "floppy_files" {
  type    = list(string)
  default = null
}
variable "headless" {
  type        = bool
  default     = true
  description = "Start GUI window to interact with VM"
}
variable "http_directory" {
  type    = string
  default = null
}
variable "iso_checksum" {
  type        = string
  default     = null
  description = "ISO download checksum"
}
variable "iso_url" {
  type        = string
  default     = null
  description = "ISO download url"
}
variable "memory" {
  type    = number
  default = null
}
variable "output_directory" {
  type    = string
  default = null
}
variable "shutdown_command" {
  type    = string
  default = null
}
variable "shutdown_timeout" {
  type    = string
  default = "15m"
}
variable "ssh_username" {
  type    = string
  default = "echoxu"
}
variable "ssh_password" {
  type    = string
  default = "echoxu"
}
variable "ssh_port" {
  type    = number
  default = 22
}
variable "ssh_timeout" {
  type    = string
  default = "120m"
}
variable "winrm_password" {
  type    = string
  default = "echoxu"
}
variable "winrm_timeout" {
  type    = string
  default = "120m"
}
variable "winrm_username" {
  type    = string
  default = "echoxu"
}
variable "vm_name" {
  type    = string
  default = null
}

# builder common block
variable "scripts" {
  type    = list(string)
  default = null
}
