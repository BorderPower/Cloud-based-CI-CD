provider "google" {
  project = var.project_id
  region  = var.region
  zone    = var.zone
}

resource "google_compute_network" "custom_network" {
  name                    = var.network_name
  auto_create_subnetworks = true
}

resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.custom_network.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}

resource "google_compute_firewall" "kubernetes-ports" {
  name    = "kubernetes-ports"
  network = google_compute_network.custom_network.name

  allow {
    protocol = "tcp"
    ports    = ["6443", "10250", "2379-2380", "30000-32767", "10255"]
  }

  allow {
    protocol = "udp"
    ports    = ["8285", "8472"]
  }

  allow {
    protocol = "tcp"
    ports    = ["53"]
  }

  allow {
    protocol = "udp"
    ports    = ["53"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["kubernetes"]
}

resource "google_compute_instance" "vm_instances" {
  count        = length(var.vm_names)
  name         = var.vm_names[count.index]
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["ssh", "kubernetes"]

  boot_disk {
    initialize_params {
      image = var.boot_image
      size  = var.boot_disk_size_gb
      type  = var.boot_disk_type
    }
  }

  network_interface {
    network = google_compute_network.custom_network.id
    access_config {}
  }

  metadata = {
    ssh-keys = "${var.ssh_user}:${var.ssh_public_key}"
  }

  

}
