packer {
  required_version = ">= 1.12.0"
  required_plugins {
    vagrant = {
      version = ">= 1.1.5"
      source  = "github.com/hashicorp/vagrant"
    }
    virtualbox = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/virtualbox"
    }
    docker = {
      version = ">= 1.1.1"
      source  = "github.com/hashicorp/docker"
    }
  }
}

locals {
  scripts = var.scripts == null ? (
    var.is_windows ? [
      ] : (
      var.os_name == "macos" ? [
        ] : (
        var.os_name == "solaris" ? [
          ] : (
          var.os_name == "freebsd" ? [
            ] : (
            var.os_name == "opensuse-leap" ||
            var.os_name == "sles" ? [
              ] : (
              var.os_name == "ubuntu" ||
              var.os_name == "debian" ? [
                "${path.root}/scripts/${var.os_name}/update_${var.os_name}.sh",
                # "${path.root}/scripts/_common/motd.sh",
                # "${path.root}/scripts/_common/sshd.sh",
                "${path.root}/scripts/${var.os_name}/networking_${var.os_name}.sh",
                # "${path.root}/scripts/${var.os_name}/sudoers_${var.os_name}.sh",
                # "${path.root}/scripts/_common/vagrant.sh",
                "${path.root}/scripts/${var.os_name}/systemd_${var.os_name}.sh",
                "${path.root}/scripts/_common/virtualbox.sh",
                # "${path.root}/scripts/_common/vmware_debian_ubuntu.sh",
                # "${path.root}/scripts/_common/parallels.sh",
                # "${path.root}/scripts/${var.os_name}/hyperv_${var.os_name}.sh",
                # "${path.root}/scripts/${var.os_name}/cleanup_${var.os_name}.sh",
                # "${path.root}/scripts/_common/parallels_post_cleanup_debian_ubuntu.sh",
                # "${path.root}/scripts/_common/minimize.sh"
                "${path.root}/scripts/${var.os_name}/base.sh",
                # "${path.root}/scripts/${var.os_name}/networking.sh",

                "${path.root}/scripts/${var.os_name}/cleanup.sh",
                "${path.root}/scripts/${var.os_name}/minimize.sh",

                ] : (
                var.os_name == "fedora" ? [
                  "{{pwd}}/scripts/base.sh",
                  "{{pwd}}/scripts/vboxguest.sh",
                  "{{pwd}}/scripts/cleanall.sh"
                  ] : (
                  "${var.os_name}-${var.os_version}" == "amazonlinux-2" ? [
                    ] : [
                    "${path.root}/scripts/rhel/update_dnf.sh",
                    "${path.root}/scripts/_common/motd.sh",
                    "${path.root}/scripts/_common/sshd.sh",
                    "${path.root}/scripts/_common/vagrant.sh",
                    "${path.root}/scripts/_common/virtualbox.sh",
                    "${path.root}/scripts/_common/vmware_rhel.sh",
                    "${path.root}/scripts/_common/parallels-rhel.sh",
                    "${path.root}/scripts/rhel/cleanup_dnf.sh",
                    "${path.root}/scripts/_common/minimize.sh"
                  ]
                )
              )
            )
          )
        )
      )
    )
  ) : var.scripts
  source_names = [for source in var.sources_enabled : trimprefix(source, "source.")]
}

# https://www.packer.io/docs/templates/hcl_templates/blocks/build
build {
  name    = "vagrant"
  sources = var.sources_enabled

  # Linux Shell scipts
  provisioner "shell" {
    environment_vars = var.os_name == "freebsd" ? [
      "HOME_DIR=/home/vagrant",
      "http_proxy=${var.http_proxy}",
      "https_proxy=${var.https_proxy}",
      "no_proxy=${var.no_proxy}",
      "pkg_branch=quarterly"
      ] : (
      var.os_name == "solaris" ? [] : [
        "HOME_DIR=/home/vagrant",
        "http_proxy=${var.http_proxy}",
        "https_proxy=${var.https_proxy}",
        "no_proxy=${var.no_proxy}"
      ]
    )
    execute_command = var.os_name == "freebsd" ? "echo 'vagrant' | {{.Vars}} su -m root -c 'sh -eux {{.Path}}'" : (
      var.os_name == "solaris" ? "echo 'vagrant'|sudo -S bash {{.Path}}" : "echo 'vagrant' | {{ .Vars }} sudo -S -E sh -eux '{{ .Path }}'"
    )
    expect_disconnect = true
    scripts           = local.scripts
    except            = var.is_windows ? local.source_names : null
  }



  # Convert machines to vagrant boxes
  post-processor "vagrant" {
    compression_level = 9
    include           = ["${path.root}/metadata/packer/ubuntu2204-virtualbox/metadata.json"]
    output            = "${path.root}/../builds/${var.os_name}-${var.os_version}-${var.os_arch}.{{ .Provider }}.box"
    vagrantfile_template = var.is_windows ? "${path.root}/vagrantfile-windows.template" : (
      var.os_name == "freebsd" ? "${path.root}/vagrantfile-freebsd.template" : "${path.root}/metadata/packer/ubuntu2204-virtualbox/Vagrantfile"
    )
  }
}


# build {
#   name = "docker"

#   sources = [
#     "source.docker.vm"
#   ]

#   post-processor "docker-save" {
#     path = "foo.tar"
#     only = [
#       "docker.vm"
#     ]
#   }

# }
