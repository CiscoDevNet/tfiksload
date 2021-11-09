data "terraform_remote_state" "host" {
  backend = "remote"
  config = {
    organization = var.org
    workspaces = {
      name = var.hostwsname
    }
  }
}

data "terraform_remote_state" "global" {
  backend = "remote"
  config = {
    organization = var.org
    workspaces = {
      name = var.globalwsname
    }
  }
}

resource "null_resource" "vm_node_init" {
  triggers = {
        trig = var.trigcount
  }
  provisioner "file" {
    source = "scripts/"
    destination = "/tmp/"
    connection {
      type = "ssh"
      host = local.host
      user = "iksadmin"
      private_key = local.privatekey
      port = "22"
      agent = false
    }
  }

  provisioner "remote-exec" {
    inline = [
        "chmod +x /tmp/gentraffic.sh",
        "/tmp/gentraffic.sh localhost 30080"
    ]
    connection {
      type = "ssh"
      host = local.host
      user = "iksadmin"
      private_key = local.privatekey
      port = "22"
      agent = false
    }
  }
}

variable "org" {
  type = string
}
variable "hostwsname" {
  type = string
}

variable "globalwsname" {
  type = string
}
variable "trigcount" {
  type = string
}
locals {
  host = data.terraform_remote_state.host.outputs.host
#  privatekey = data.terraform_remote_state.global.outputs.privatekey
  privatekey = base64decode(data.terraform_remote_state.global.outputs.privatekey)
}



