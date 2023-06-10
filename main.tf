##### Create Resource Group #####
resource "azurerm_resource_group" "main" {
  name     = var.resource_group.name
  location = var.location.main
  tags = {
    env = var.app_service_plan.tags.env
  }
}

##### Create AppService Plan #####
resource "azurerm_service_plan" "main" {
  name                = var.app_service_plan.name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location.main
  os_type             = var.app_service_plan.os_type
  sku_name            = var.app_service_plan.sku_name

  tags = {
    env = var.app_service_plan.tags.env
  }
}

##### Create LogAnalytics #####
resource "azurerm_log_analytics_workspace" "main" {
  name                = var.log_analytics.name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location.main
  sku                 = var.log_analytics.sku
  retention_in_days   = var.log_analytics.retention_in_days
  daily_quota_gb      = var.log_analytics.daily_quota_gb
}

##### Create ApplicationInsights #####
resource "azurerm_application_insights" "main" {
  name                = var.application_insights.name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location.main
  workspace_id        = azurerm_log_analytics_workspace.main.id
  application_type    = var.application_insights.application_type
  tags = {
    env = var.app_service_plan.tags.env
  }
}

##### Create Frontend WebApp #####
resource "azurerm_linux_web_app" "main" {
  for_each            = var.app_service
  name                = each.value.name
  resource_group_name = var.app_service_plan.resource_group_name
  location            = var.app_service_plan.location
  service_plan_id     = azurerm_service_plan.main.id
  https_only          = true
  tags = {
    env = var.app_service_plan.tags.env
  }

  site_config {
    application_stack {
      node_version = "18-lts"
    }
    minimum_tls_version = "1.2"
    ftps_state          = "Disabled"
    always_on           = "true"
  }

  app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"             = "${azurerm_application_insights.main.instrumentation_key}"
    "ApplicationInsightsAgent_EXTENSION_VERSION" = "~2"
    "APPINSIGHTS_PROFILERFEATURE_VERSION"        = "1.0.0"
    "DiagnosticServices_EXTENSION_VERSION"       = "~3"
    "XDT_MicrosoftApplicationInsights_Mode"      = "recommended"
  }

  identity {
    type = "SystemAssigned"
  }

}
