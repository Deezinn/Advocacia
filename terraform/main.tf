provider "azurerm" {
  features {}
  subscription_id = var.subscription_id
  client_id       = var.client_id
  client_secret   = var.client_secret
  tenant_id       = var.tenant_id
}

# Variáveis do Terraform
variable "subscription_id" {}
variable "client_id" {}
variable "client_secret" {}
variable "tenant_id" {}

# Criar o grupo de recursos
resource "azurerm_resource_group" "rg" {
  name     = "my-dash-app-rg"
  location = "East US"
}

# Criar o plano de serviço (Linux para Docker) com SKU B1
resource "azurerm_service_plan" "app_service_plan" {
  name                = "my-dash-app-service-plan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  sku_name            = "B1"  # SKU B1 (Plano básico)
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
    linux_fx_version = "DOCKER|deezinn/my-dash-app:latest"
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
