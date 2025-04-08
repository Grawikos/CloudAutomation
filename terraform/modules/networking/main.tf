resource "aws_cloudformation_stack" "networking" {
  name          = var.stack_name
  template_body = file(var.template_path)

  parameters = {
    VPCCIDR            = var.vpc_cidr
    PublicSubnet1CIDR  = var.public_subnet1_cidr
    PublicSubnet2CIDR  = var.public_subnet2_cidr
    PrivateSubnet1CIDR = var.private_subnet1_cidr
    PrivateSubnet2CIDR = var.private_subnet2_cidr
    AvailabilityZone1  = var.availability_zone1
    AvailabilityZone2  = var.availability_zone2
  }

}
