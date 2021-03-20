terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
    }
  }
}

variable "hcloud_token" {}

provider "hcloud" {
  token = var.hcloud_token
}

data "template_file" "script" {
    template = file("${path.module}/user-data/script.tpl")
}

resource "hcloud_server" "minecraft" {
  name        = "minecraft"
  image       = "debian-10"
  server_type = "cpx31"
  location    = "hel1"
  ssh_keys    = ["sandbox@hetzner"]
  keep_disk   = "true"
  labels = {
    stage = "test"
    minecraft = "hosts"
  }
  backups = "false"
  user_data = data.template_file.script.rendered
}
