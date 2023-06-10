terraform {
  required_version = "~> 1.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0.0"
    }
  }
}

provider "azurerm" {
  features {}
  subscription_id = local.login.subscription_id
  tenant_id       = local.login.tenant_id
}

module "main" {
  source = "../../"

  location             = local.location
  resource_group       = local.resource_group
  app_service_plan     = local.app_service_plan
  log_analytics        = local.log_analytics
  application_insights = local.application_insights
  app_service          = local.app_service
}
