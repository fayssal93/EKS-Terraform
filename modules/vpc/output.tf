output "vpc_id" {
  value       = aws_vpc.vpc_devops.id
  description = "VPC id"
  sensitive   = false
}

output "internet_gateway_id" {
  value = aws_internet_gateway.devops_igw.id
}

output "rt_devops_public_id" {
  value = aws_route_table.rt_devops_public.id
}

output "rt_devops_private1_id" {
  value = aws_route_table.rt_devops_private1.id
}

output "rt_devops_private2_id" {
  value = aws_route_table.rt_devops_private2.id
}

output "sn_public_1_id"{
  value = aws_subnet.sn_public_1.id
}

output "sn_public_2_id"{
  value = aws_subnet.sn_public_2.id
}

output "sn_private_1_id"{
  value = aws_subnet.sn_public_1.id
}

output "sn_private_2_id"{
  value = aws_subnet.sn_public_2.id
}