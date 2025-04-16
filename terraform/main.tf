provider "azurerm" {
  features {}
  subscription_id = "62a47bad-99aa-450d-a7e2-ef75d08015f4"  # Sua Subscription ID
}

# Criar o grupo de recursos
resource "azurerm_resource_group" "rg" {
  name     = "my-dash-app-rg"
  location = "East US"
}

# Criar o plano de serviço (Linux para Docker) com SKU F1
resource "azurerm_service_plan" "app_service_plan" {
  name                = "my-dash-app-service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "B1"  # SKU F1 (Plano gratuito)
  os_type             = "Linux"  # Tipo de sistema operacional (Linux)

  tags = {
    environment = "production"
  }
}

# Criar o App Service que vai rodar o container
resource "azurerm_linux_web_app" "app" {
  name                = "my-dash-web-app"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  service_plan_id     = azurerm_service_plan.app_service_plan.id

  site_config {
    # Remover linux_fx_version, e usar a configuração customizada para o Docker
  }

  app_settings = {
    "WEBSITES_PORT"            = "8050"  # Porta onde o app vai rodar
    "DOCKER_CUSTOM_IMAGE_NAME" = "deezinn/my-dash-app:latest"
  }

  tags = {
    environment = "production"
  }

  depends_on = [azurerm_service_plan.app_service_plan]
}
