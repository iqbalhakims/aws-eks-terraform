resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" " subnet_1"{
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "10.0.0.0/20
  availability_zone       = " ap-southeast-1"
  map_public_ip_on_launch = true

resource "aws_internet_gateway" "eks-gateway"{
  vpc_id = aws_vpc.main.id 
}

resource "aws_route_table" "main"{
  vpc_id = aws_internet_gateway.main.id 
}
 route {
  cidr_block = "0.0.0.0/16"
  gateway_id = aws_internet_gateway.main.id 
 }
 route {
  cidr_block = "10.0.0.0/16"
  gateway_id = " local"
 }

}


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 19.0"

  cluster_name    = "iqbal-eks"
  cluster_version = "1.29"

  cluster_endpoint_public_access = true

  vpc_id                   = aws_vpc.main.id
  subnet_ids               = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id, aws_subnet.subnet_3.id]
  control_plane_subnet_ids = [aws_subnet.subnet_1.id, aws_subnet.subnet_2.id, aws_subnet.subnet_3.id]

  eks_managed_node_groups = {
    green = {
      min_size       = 1
      max_size       = 1
      desired_size   = 1
      instance_types = ["t3.medium"]
    }
  }
}

