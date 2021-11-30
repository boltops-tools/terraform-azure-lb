# Terraform Azure Load Balancer

[![BoltOps Badge](https://img.boltops.com/boltops/badges/boltops-badge.png)](https://www.boltops.com)

Simple example with:

* [azurerm_lb](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/lb)

## Add to Terrafile

```ruby
mod "lb", source: "boltops-tools/lb/azure"
```

## Import Example

    terraspace bundle # installs to vendor/modules/lb
    terraspace bundle example lb linux_scaleset_lb # imports to app/stacks/linux_scaleset_lb

## Configure Tfvars

    terraspace seed linux_scaleset_lb # creates starter app/stacks/linux_scaleset_lb/tfvars/dev.tfvars

## Deploy

    terraspace up linux_scaleset_lb

## Clean Up

    terraspace down linux_scaleset_lb

