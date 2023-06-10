locals {
  login = {
    subscription_id = ""
    tenant_id       = ""
  }

  ##### Geo-Location #####
  location = {
    main = "japaneast"
    sub  = "japanwest"
  }

  ##### Enviroment Name #####
  enviroment = {
    env = "dev"
  }

  ##### Service Common Name #####
  service = {
    service_name = "your-service-name"
  }

  ##### Resource Group Name #####
  resource_group = {
    name = "${local.enviroment.env}-${local.service.service_name}"
  }

  ##### AppService Plan #####
  app_service_plan = {
    name                = "${local.enviroment.env}-${local.service.service_name}"
    location            = local.location.main
    resource_group_name = local.resource_group.name
    os_type             = "Linux"
    sku_name            = "P1v3"
    tags = {
      env = local.enviroment.env
    }
  }

  ##### Log Analytics WorkSpace #####
  log_analytics = {
    name                = "${local.enviroment.env}-${local.service.service_name}"
    location            = local.location.main
    resource_group_name = local.resource_group.name
    sku                 = "PerGB2018"
    retention_in_days   = 30
    daily_quota_gb      = 1
  }

  ##### Application Insights #####
  application_insights = {
    name                = "${local.enviroment.env}-${local.service.service_name}"
    location            = local.location.main
    resource_group_name = local.resource_group.name
    application_type    = "web"
  }

  #####  WebApp #####
  app_service = {
    app1 = {
      name = "${local.enviroment.env}-${local.service.service_name}-app1"
    }
    app2 = {
      name = "${local.enviroment.env}-${local.service.service_name}-app2"
    }
  }
}
