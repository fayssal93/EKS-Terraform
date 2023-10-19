resource "aws_eip" "eip_nat1" {
  depends_on = [var.internet_gateway_id]
  tags = {
    Name = "eip_nat1"
  }
}

resource "aws_eip" "eip_nat2" {
  depends_on = [var.internet_gateway_id]
  tags = {
    Name = "eip_nat2"
  }
}

# create nat gateway pour le subnet public 1 
resource "aws_nat_gateway" "nat_gw1" {
  allocation_id = aws_eip.eip_nat1.id
  subnet_id = var.sn_public_1_id
  tags = {
    Name = "nat_gw1"
  }
}

# create nat gateway pour le subnet public 2 
resource "aws_nat_gateway" "nat_gw2" {
  allocation_id = aws_eip.eip_nat2.id
  subnet_id = var.sn_public_2_id
  tags = {
    Name = "nat_gw2"
  }

}

# ajout d'une route dans la table de route prive 1 qui envoie le traffic vers la nat gateway 1
resource "aws_route" "private1_subnet_route"{
    route_table_id = var.rt_devops_private1_id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw1.id
}

# ajout d'une route dans la table de route prive 2 qui envoie le traffic vers la nat gateway 2
resource "aws_route" "private1_subnet_route"{
    route_table_id = var.rt_devops_private1_id
    destination_cidr_block = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat_gw1.id
}

# ajout d'une route dans la table de route public qui envoie le traffic vers internet gateway
resource "aws_route" "private2_subnet_route"{
    route_table_id = var.rt_devops_public
    destination_cidr_block = "0.0.0.0/0"
    gateway_id = var.internet_gateway_id
}