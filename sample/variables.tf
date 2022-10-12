# 環境変数（Azureサービスプリンシパル）
variable "ARM_TENANT_ID" {}
variable "ARM_SUBSCRIPTION_ID" {}
variable "ARM_CLIENT_ID" {}
variable "ARM_CLIENT_SECRET" {}

# タグ情報
variable "tags_def" {
  default = {
    owner       = "yuuma"
    period      = "2022-04-28"
    CostCenter  = "PSG2"
    Environment = "CPDemo"
  }
}

# 各種パラメータ
variable "region" {}              // 利用リージョン
variable "resource_group_name" {} // リソースグループ名

variable "vnet_name" {}          // vNet名
variable "vnet_address_space" {} // vNetアドレス範囲
variable "subnet_name" {}        // サブネット名
variable "subnet_address" {}     // サブネットアドレス
variable "dns_service_ip" {}     // サービス用DNSアドレス
variable "docker_address" {}     // Dockerブリッジアドレス
variable "service_address" {}    // サービス用ネットワークアドレス

variable "aks_cluster_name" {}       // AKSクラスタ名
variable "dns_prefix" {}             // DNSプレフィックス
variable "default_node_pool_name" {} // ノードプール名
variable "enable_auto_scaling" {}    // 自動拡張可否
variable "vm_size" {}                // 仮想マシンサイズ
variable "node_count" {}             // 起動時ノード数
variable "max_count" {}              // 最大ノード数
variable "min_count" {}              // 最小ノード数
