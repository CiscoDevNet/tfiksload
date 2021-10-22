data "terraform_remote_state" "host" {
  backend = "remote"
  config = {
    organization = var.org
    workspaces = {
      name = var.hostwsname
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
      private_key = var.privatekey
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
      private_key = var.privatekey
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

variable "privatekey" {
  type = string
}
variable "trigcount" {
  type = string
}
locals {
  host = data.terraform_remote_state.host.outputs.host
}



