#création de VPC
resource "aws_vpc" "vpc_devops" {
  cidr_block = var.vpc_cidr

  instance_tenancy = "default"

  enable_dns_support = true

  enable_dns_hostnames = true

  #enable_classisclink_dns_suport = false

  assign_generated_ipv6_cidr_block = false

  tags = {
    Name = var.vpc_devops
  }
}

#use data source to get all avalablility zones in region
data "aws_availability_zones" "available_zones" {}

# create internet gateway and attach it to vpc
resource "aws_internet_gateway" "devops_igw" {
  vpc_id = aws_vpc.vpc_devops.id
}

# create public subnet dans l'availibility zone 1
resource "aws_subnet" "sn_public_1" {
  vpc_id                  = aws_vpc.vpc_devops.id
  cidr_block              = var.sn_public_1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = true

   tags = {
    Name                        = "sn_public_1"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1
  }
}

# create public subnet dans l'availibility zone 2
resource "aws_subnet" "sn_public_2" {
  vpc_id                  = aws_vpc.vpc_devops.id
  cidr_block              = var.sn_public_2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = true

  tags = {
    Name                        = "sn_public_2"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1
  }
}


# create route table public
resource "aws_route_table" "rt_devops_public" {
  vpc_id = aws_vpc.vpc_devops.id
  #ajouter une route public vers internet gateway dans le module nat
  tags = {
    Name = "rt_devops_public"
  }

}

# associate public subnet az1 to route table public
resource "aws_route_table_association" "public1_sn_1_rt_tbl_associat" {
  subnet_id      = aws_subnet.sn_public_1.id
  route_table_id = aws_route_table.rt_devops_public.id
}

# associate public subnet az2 to "public route table"
resource "aws_route_table_association" "public2_sn_rt_tbl_associat" {
  subnet_id      = aws_subnet.sn_public_2.id
  route_table_id = aws_route_table.rt_devops_public.id
}


# create private subnet dans l'availibility zone 1
resource "aws_subnet" "sn-private_1" {
  vpc_id                  = aws_vpc.vpc_devops.id
  cidr_block              = var.sn_private_1_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[0]
  map_public_ip_on_launch = false

  tags = {
    Name                        = "sn-private_1"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1
  }
}

# create private subnet dans l'availibility zone 2
resource "aws_subnet" "sn-private_2" {
  vpc_id                  = aws_vpc.vpc_devops.id
  cidr_block              = var.sn_private_2_cidr
  availability_zone       = data.aws_availability_zones.available_zones.names[1]
  map_public_ip_on_launch = false

  tags = {
    Name                        = "sn-private_2"
    "kubernetes.io/cluster/eks" = "shared"
    "kubernetes.io/role/elb"    = 1
  }
}

# create route table prive 1 
resource "aws_route_table" "rt_devops_private1" {
  vpc_id = aws_vpc.vpc_devops.id
  
  #ajouter une route de cette table vers la nat gateway dans le module nat
  tags = {
    Name = "rt_devops_private1"
  }

}

# create route table prive 2
resource "aws_route_table" "rt_devops_private2" {
  vpc_id = aws_vpc.vpc_devops.id
  #ajouter une route de cette table vers la nat gateway dans le module nat

   tags = {
    Name = "rt_devops_private2"
  }

}

# association de la table de route prive1 au subnet prive 1  
resource "aws_route_table_association" "private1_sn_rt_tbl_associat" {
  subnet_id = aws_subnet.sn-private_1.id
  route_table_id = aws_route_table.rt_devops_private1.id 
}

# association de la table de route prive2 au subnet prive 2  
resource "aws_route_table_association" "private2_sn_rt_tbl_associat" {
  subnet_id = aws_subnet.sn-private_2.id
  route_table_id = aws_route_table.rt_devops_private2.id 
}