provider "google" {
  credentials = "${file("${path.module}/account_json")}"
  project     = "${var.gcp_project}"
  region      = "europe-west1"
}

resource "google_compute_instance" "jumpbox" {
  name         = "jumpbox"
  machine_type = "n1-standard-2"
  zone         = "europe-west1-c"

  disk {
    image = "ubuntu-1604-lts"
  }

  // Local SSD disk
  disk {
    type    = "local-ssd"
    scratch = true
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

}

output "jumpbox_ip" {
  value = "${google_compute_instance.jumpbox.network_interface.access_config.nat_ip}"
}

output "jumpbox_user" {
  value = "${var.jumpbox_user}"
}

output "ssh_port" {
  value = "${var.ssh_port}"
}

output "public_key" {
  value = "${file("${var.platform_public_key_path}")}"
}
