# AKS

## terraformでリソースグループ作成

### main.tfというファイルを作成
```terraform
# プロバイダーの定義
terraform {
  required_providers {
    azurerm =  "~> 2.33"
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
```

### variables.tfを作成
```terraform
# 環境変数（Azureサービスプリンシパル）
variable ARM_TENANT_ID {}
variable ARM_SUBSCRIPTION_ID {}
variable ARM_CLIENT_ID {}
variable ARM_CLIENT_SECRET {}

# タグ情報
variable tags_def {
  default = {
    owner      = "ituru"
    period     = "2022-04-28"
    CostCenter = "PSG2"
    Environment = "CPDemo"
  }
}

# 各種パラメータ
variable region {}                  // 利用リージョン
variable resource_group_name {}     // リソースグループ名

variable vnet_name {}               // vNet名
variable vnet_address_space {}      // vNetアドレス範囲
variable subnet_name {}             // サブネット名
variable subnet_address {}          // サブネットアドレス
variable dns_service_ip {}          // サービス用DNSアドレス
variable docker_address {}          // Dockerブリッジアドレス
variable service_address {}         // サービス用ネットワークアドレス

variable aks_cluster_name {}        // AKSクラスタ名
variable dns_prefix {}              // DNSプレフィックス
variable default_node_pool_name {}  // ノードプール名
variable enable_auto_scaling {}     // 自動拡張可否
variable vm_size {}                 // 仮想マシンサイズ
variable node_count {}              // 起動時ノード数
variable max_count {}               // 最大ノード数
variable min_count {}               // 最小ノード数
```


### terraform.tfvarsを作成
```terraform 
# 環境変数の定義（Azureサービスプリンシパル）
ARM_TENANT_ID       = "zzzzzzzz-cccc-4645-5757-zzzzzzzzzzzz"
ARM_SUBSCRIPTION_ID = "xxxxxxxx-1717-dada-9779-zzzzzzzzzzzz"
ARM_CLIENT_ID       = "xxxxxxxx-xxxx-4444-9922-xxxxxxxxxxxx"
ARM_CLIENT_SECRET   = "hogehogehogehogehogehogehogehogege"

# パラメータ値の定義
region                  = "japaneast"           // 利用リージョン
resource_group_name     = "rg_ituru_aks01"      // リソースグループ名

vnet_name               = "vnet_ituru_aks01"    // vNet名
vnet_address_space      = "10.0.0.0/16"         // vNetアドレス範囲
subnet_name             = "snet_ituru_aks01"    // サブネット名
subnet_address          = "10.0.1.0/24"         // サブネットアドレス
dns_service_ip          = "10.1.0.10"           // サービス用DNSアドレス
docker_address          = "172.17.0.1/16"       // Dockerブリッジアドレス
service_address         = "10.1.0.0/24"         // サービス用ネットワークアドレス

aks_cluster_name        = "aks_ituru_cp01"      // AKSクラスタ名
dns_prefix              = "cpcluster01"         // DNSプレフィックス
default_node_pool_name  = "cpdemo01"            // ノードプール名
enable_auto_scaling     = "true"                // 自動拡張可否
vm_size                 = "Standard_D2_v2"      // 仮想マシンサイズ
node_count              = "3"                   // 起動時ノード数
max_count               = "5"                   // 最大ノード数
min_count               = "3"                   // 最小ノード数
```

### aks.tf作成
```terraform
# AKS
resource "azurerm_kubernetes_cluster" "this" {
  name                = var.aks_cluster_name
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  dns_prefix          = var.dns_prefix
  tags                = var.tags_def

  default_node_pool {
    name                = var.default_node_pool_name
    vm_size             = var.vm_size
    node_count          = var.node_count
    vnet_subnet_id      = azurerm_subnet.internal.id
    type                = "VirtualMachineScaleSets"
    tags                = var.tags_def

    enable_auto_scaling = var.enable_auto_scaling
    max_count           = var.max_count
    min_count           = var.min_count
  }

  service_principal {
    client_id     = var.ARM_CLIENT_ID
    client_secret = var.ARM_CLIENT_SECRET
  }

  network_profile {
    network_plugin     = "azure"
    network_policy     = "calico"
    dns_service_ip     = var.dns_service_ip
    docker_bridge_cidr = var.docker_address
    service_cidr       = var.service_address
    load_balancer_sku  = "Standard"
  }

  lifecycle {
    prevent_destroy = true
  }
}
```

### network.tf
```terraform 
// 仮想ネットワーク
resource "azurerm_virtual_network" "this" {
  name                = var.vnet_name
  address_space       = [var.vnet_address_space]
  location            = azurerm_resource_group.this.location
  resource_group_name = azurerm_resource_group.this.name
  tags                = var.tags_def
}

// サブネット
resource "azurerm_subnet" "internal" {
  name                  = var.subnet_name
  resource_group_name   = azurerm_resource_group.this.name
  virtual_network_name  = azurerm_virtual_network.this.name
  address_prefixes      = [var.subnet_address]
}
```

### output.tf作成
```terraform
# AKSクラスタのクライアント証明書を出力
output "client_certificate" {
  value = azurerm_kubernetes_cluster.this.kube_config.0.client_certificate
}

# AKSクラスタのkubeconfigを出力
output "kube_config" {
  value = azurerm_kubernetes_cluster.this.kube_config_raw
  sensitive = true
}

# AKSクラスタのFQDNを出力
output "fqdn" {
  value = azurerm_kubernetes_cluster.this.fqdn
}

# AKSクラスタのIDを出力
output "cluster_id" {
  value = azurerm_kubernetes_cluster.this.id
}
```

### terraform初期化
```console
$ terraform init
```

### terraform実行プラン作成
```
$ terraform plan
```

### terraform 実行プラン適用
```console
$ terraform plan
$ terraform apply
```

### AKSクラスタ確認
```console
$ az aks list -g [リソースグループ名] table -o
```

### AKSノードプール
```
$ az aks nodepool list -g [リソースグループ名] --cluster-name [クラスタ名] -o table
```

### AKSクラスタ起動
```console
$ az aks start -g [リソースグループ名] -n [クラスタ名]
```


## ローカルからAKSクラスタへ接続
```console
$ az aks get-credentials --resource-group [リソースグループ名] --name [クラスター名]
```

## AKSノード確認
```console
$ kubectl get nodes
```

## Helm導入
```console
$ brew update
$ brew install kubernetes-helm
```

## サービスアカウントを作成
Istioをデプロイする前にTillerのサービスアカウントとロールバインディングを作成する必要があるので、以下のように'helm-rbac.yaml'を作成
```yaml
apiVersion: v1
kind: ServiceAccount
metadata:
  name: tiller
  namespace: kube-system
---
apiVersion: rbac.authorization.k8s.io/v1beta1
kind: ClusterRoleBinding
metadata:
  name: tiller
roleRef:
  apiGroup: rbac.authorization.k8s.io
  kind: ClusterRole
  name: cluster-admin
subjects:
  - kind: ServiceAccount
    name: tiller
    namespace: kube-system
```

## AKSクラスタに対してサービスアカウントとロールバインディングの作成を実行
```console
$ kubectl create -f helm-rbac.yaml

serviceaccount "tiller" created
clusterrolebinding "tiller" created
```

## Istioの導入
Istioをデプロイする前に、Helmそのものとサーバ側コンポーネントであるTillerを有効化する
```console
$ helm init --service-account tiller
```


```console

```
```console

```
```console

```
```console

```
```console

```