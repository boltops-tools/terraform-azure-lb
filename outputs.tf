output "backend_address_pool_id" {
  value = azurerm_lb_backend_address_pool.this.id
}

output "probe_id" {
  value = azurerm_lb_probe.this.id
}

output "public_ip" {
  value = data.azurerm_public_ip.this.ip_address
}
