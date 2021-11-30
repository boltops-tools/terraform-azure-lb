data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

module "lb" {
  source = "../.."

  resource_group_name = var.resource_group_name
  enable_probe_id = var.enable_probe_ids

  # name = "demo-lb"
}

locals {
  custom_data = <<EOL
#!/bin/bash
sudo apt install apache2 -y
  EOL
}

module "scaleset" {
  source = "boltops-tools/linux-virtual-machine-scale-set/azure"

  resource_group_name = var.resource_group_name
  subnet_id = module.vnet.vnet_subnets.default.id
  load_balancer_backend_address_pool_ids = [module.lb.backend_address_pool_id]
  enable_health_probe_id = var.enable_probe_ids
  health_probe_id = module.lb.probe_id
  custom_data = local.custom_data

  # name = "linux-scaleset"
  # instances = 1
}

module "vnet" {
  source = "boltops-tools/network/azure"

  resource_group_name = var.resource_group_name
  address_space       = "10.0.0.0/16" # full address space about 64k address
  subnets = {
    "default" = {
      address_prefixes = ["10.0.0.0/17"] # half the address space. about 32k addresses
    }
  }

  # vnet_name           = var.vnet_name
  # dns_servers         = var.dns_servers
  # tags                = var.tags
}

resource "azurerm_network_security_group" "this" {
  name                = "linux-scaleset-nsg"
  location            = data.azurerm_resource_group.this.location
  resource_group_name = data.azurerm_resource_group.this.name

  security_rule {
    name                       = "ssh"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  security_rule {
    name                       = "http"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "80"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "this" {
  subnet_id                 = module.vnet.vnet_subnets.default.id
  network_security_group_id = azurerm_network_security_group.this.id
}