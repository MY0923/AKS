# プロバイダーの定義
terraform {
  required_providers {
    azurerm = "~> 2.33"
  }
}

provider "azurerm" {
  features {}
  tenant_id       = var.ARM_TENANT_ID
  subscription_id = var.ARM_SUBSCRIPTION_ID
  client_id       = var.ARM_CLIENT_ID
  client_secret   = var.ARM_CLIENT_SECRET
}


# リソースグループ
resource "azurerm_resource_group" "this" {
  name     = var.resource_group_name
  location = var.region
  tags     = var.tags_def
}
