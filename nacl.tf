resource "aws_network_acl" "eks-external-zone" {
  vpc_id = aws_vpc.main.id

  subnet_ids = aws_subnet.public.*.id

  tags = merge({
    Name = "eks-external-zone"
    }, var.standard_tags
  )
}

resource "aws_network_acl_rule" "eks-ingress-external-zone-rules" {
  network_acl_id = aws_network_acl.eks-external-zone.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "eks-egress-external-zone-rules" {
  network_acl_id = aws_network_acl.eks-external-zone.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl" "eks-internal-zone" {
  vpc_id = aws_vpc.main.id

  subnet_ids = aws_subnet.private.*.id

  tags = merge({
    Name = "eks-internal-zone"
    }, var.standard_tags
  )
}

resource "aws_network_acl_rule" "ingress-internal-zone-rules" {
  network_acl_id = aws_network_acl.eks-internal-zone.id
  rule_number    = 100
  egress         = false
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}

resource "aws_network_acl_rule" "egress-internal-zone-rules" {
  network_acl_id = aws_network_acl.eks-internal-zone.id
  rule_number    = 100
  egress         = true
  protocol       = "-1"
  rule_action    = "allow"
  cidr_block     = "0.0.0.0/0"
  from_port      = 0
  to_port        = 0
}
