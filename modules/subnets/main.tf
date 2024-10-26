data "yandex_vpc_network" "infra" {
  network_id = var.vpc_id
}

resource "yandex_vpc_subnet" "subnets" {
  folder_id      = var.folder_id
  for_each       = { for k, v in var.subnets : v["name"] => v }
  network_id     = var.vpc_id
  zone           = each.value["zone"]
  name           = each.key
  v4_cidr_blocks = [each.value["cidr"], ]

  route_table_id = each.value["nat"] == true && ((var.gw_ip_address != null) || var.gateway) ? yandex_vpc_route_table.route_table[0].id : null
}

resource "yandex_vpc_route_table" "route_table" {
  count      = (var.gw_ip_address != null) || var.gateway ? 1 : 0
  folder_id  = var.folder_id
  network_id = var.vpc_id

  static_route {
    destination_prefix = "0.0.0.0/0"
    next_hop_address   = (var.gw_ip_address != null) && (!var.gateway) ? var.gw_ip_address : null
    gateway_id         = var.gateway ? yandex_vpc_gateway.gateway[0].id : null
  }
}

resource "yandex_vpc_gateway" "gateway" {
  count     = var.gateway ? 1 : 0
  folder_id = var.folder_id
  name      = "gw-egress-${data.yandex_vpc_network.infra.name}"
  shared_egress_gateway {}
}
