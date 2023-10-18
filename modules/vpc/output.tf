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