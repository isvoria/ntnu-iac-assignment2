terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.0.1"
    }
  }

  backend "azurerm" {
    resource_group_name  = "resource-group-backend-ok-tfstate"
    storage_account_name = "backendok7b47m"
    container_name       = "storage-container-backend-ok-tfstate"
    key                  = "oblig2.terraform.tfstate"
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id

  features {}
}

data "azurerm_client_config" "current" {}

resource "random_string" "random_string" {
    length = 5
    special = false
    upper = false
}

resource "azurerm_resource_group" "resource_group" {
  name     = "resource-group-ok-${terraform.workspace}"
  location = var.location
}

module "virtual_network" {
  source              = "../modules/virtual_network"
  vnet_name           = "vnet-${terraform.workspace}"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
  address_space       = var.address_space
  subnet_name         = "subnet-${terraform.workspace}"
  subnet_prefixes     = var.subnet_prefixes
}

module "app_service_plan" {
  source                = "../modules/app_service_plan"
  app_service_plan_name = "asp-${terraform.workspace}"
  location              = var.location
  resource_group_name   = azurerm_resource_group.resource_group.name
  os_type               = "Linux"
  sku_name              = var.aps_sku
}

module "sql_database" {
  source              = "../modules/sql_database"
  sql_server_name     = "sql-${terraform.workspace}-${random_string.random_string.result}"
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  database_name       = "db-${terraform.workspace}"
  resource_group_name = azurerm_resource_group.resource_group.name
  location            = var.location
  sku_name            = var.sql_sku
}

module "blob_storage" {
  source               = "../modules/blob_storage"
  storage_account_name = "storageok${random_string.random_string.result}"
  resource_group_name  = azurerm_resource_group.resource_group.name
  location             = var.location
  container_name       = "images-${terraform.workspace}"
}

module "load_balancer" {
  source              = "../modules/load_balancer"
  lb_name             = "lb-${terraform.workspace}"
  location            = var.location
  resource_group_name = azurerm_resource_group.resource_group.name
}
