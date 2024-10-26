
output "subnet_ids" {
  value = { for k, v in var.subnets : v["name"] => yandex_vpc_subnet.subnets[v["name"]].id }
}
