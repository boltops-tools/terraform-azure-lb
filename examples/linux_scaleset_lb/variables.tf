variable "resource_group_name" {
  description = "The name of an existing resource group to be imported."
  type        = string
}

variable "enable_probe_ids" {
  description = "Enables health check probe ids for both Scale Set and Load Balancer. Both must be set to the same value. Also enables the rolling upgrade policy, which requires a health check. Useful to disable when changing the name of the ScaleSet as the update fails when probe ids are in place during a rename. Also, need to disable when destroying all resources."
  type        = bool
  default     = false
}