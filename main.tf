data "azurerm_resource_group" "this" {
  name = var.resource_group_name
}

resource "azurerm_lb" "this" {
  name                = var.name
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location

  frontend_ip_configuration {
    name                 = "PublicIpAddress"
    public_ip_address_id = azurerm_public_ip.this.id
  }
}

resource "azurerm_public_ip" "this" {
  name                = "${var.name}-public-ip"
  resource_group_name = data.azurerm_resource_group.this.name
  location            = data.azurerm_resource_group.this.location
  allocation_method   = "Static"
}

# For output lb_public_ip
data "azurerm_public_ip" "this" {
  name                = azurerm_public_ip.this.name
  resource_group_name = data.azurerm_resource_group.this.name
}

resource "azurerm_lb_backend_address_pool" "this" {
  loadbalancer_id = azurerm_lb.this.id
  name            = "BackEndAddressPool"
}

resource "azurerm_lb_rule" "this" {
  resource_group_name            = data.azurerm_resource_group.this.name
  loadbalancer_id                = azurerm_lb.this.id
  name                           = "http"
  protocol                       = "Tcp"
  frontend_port                  = var.frontend_port
  backend_port                   = var.backend_port
  backend_address_pool_ids       = [azurerm_lb_backend_address_pool.this.id]
  frontend_ip_configuration_name = "PublicIpAddress"
  probe_id                       = var.enable_probe_id ? azurerm_lb_probe.this.id : null
}

resource "azurerm_lb_probe" "this" {
  resource_group_name = data.azurerm_resource_group.this.name
  loadbalancer_id     = azurerm_lb.this.id
  name                = "http-probe"
  port                = var.backend_port
}
