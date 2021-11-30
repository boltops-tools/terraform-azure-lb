variable "resource_group_name" {
  description = "The name of an existing resource group to be imported."
  type        = string
}

variable "name" {
  description = "Load Balancer name"
  type        = string
  default     = "demo-lb"
}

variable "enable_probe_id" {
  description = "Enables Load Balancer probe id."
  type        = bool
  default     = false
}

variable "frontend_port" {
  description = "Frontend port"
  type        = string
  default     = 80
}

variable "backend_port" {
  description = "Backend port"
  type        = string
  default     = 80
}
