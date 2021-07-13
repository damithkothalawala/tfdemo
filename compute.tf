## Copyright © 2020, Oracle and/or its affiliates. 
## All rights reserved. The Universal Permissive License (UPL), Version 1.0 as shown at http://oss.oracle.com/licenses/upl

# This Terraform script provisions a compute instance

resource "oci_core_instance" "compute_instance" {
  availability_domain = lookup(data.oci_identity_availability_domains.ads.availability_domains[var.availability_domain],"name")
  compartment_id = var.compartment_ocid
  display_name = "demo-instance"
  shape = var.instance_shape
  fault_domain        = "FAULT-DOMAIN-1"

  create_vnic_details {
    subnet_id = oci_core_subnet.subnet_1.id
    ## display_name = "primaryvnic"
    ## assign_public_ip = true
    ## nsg_ids = [oci_core_network_security_group.SSHSecurityGroup.id]
  }

  metadata = {
    ssh_authorized_keys = chomp(file(var.ssh_public_key))
  }

   source_details {
    source_type             = "image"
    source_id               = "ocid1.image.oc1.ap-mumbai-1.aaaaaaaaxbhf3d2m3jhsosvsosoi33yn7msdubh33sbrziyyteqguqpg6zia"
    #source_id               = data.oci_core_images.InstanceImageOCID.images[0].id
    boot_volume_size_in_gbs = "50"
  }

  timeouts {
    create = "60m"
  }
}
