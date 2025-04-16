provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "my-dash-app-rg"
  location = "East US"
}

resource "azurerm_service_plan" "app_service_plan" {
  name                = "my-dash-app-service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Linux"
  reserved            = true
  sku {
    tier = "Basic"
    size = "B1"
  }
}

resource "azurerm_linux_web_app" "app" {
  name                = "my-dash-web-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  app_settings = {
    DOCKER_CUSTOM_IMAGE_NAME = "deezinn/my-dash-app:latest"
    WEBSITES_PORT            = "8050"
  }

  # Removido o linux_fx_version, pois o Terraform configura automaticamente
}

output "app_url" {
  value = azurerm_linux_web_app.app.default_site_hostname
}
