#######################################
# DB Subnet Group
#######################################

resource "aws_db_subnet_group" "this" {
  name       = "${var.name}-db-subnet-group"
  subnet_ids = var.subnet_ids

  tags = merge(
    {
      Name = "${var.name}-db-subnet-group"
    },
    var.tags
  )
}

#######################################
# Security Group
#######################################

resource "aws_security_group" "this" {
  name        = "${var.name}-db-sg"
  description = "Security group for RDS / Aurora"
  vpc_id     = var.vpc_id

  ingress {
    description = "DB access"
    from_port   = var.port
    to_port     = var.port
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidrs
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    {
      Name = "${var.name}-db-sg"
    },
    var.tags
  )
}

#######################################
# Parameter Group
#######################################

resource "aws_db_parameter_group" "rds" {
  count = var.use_aurora ? 0 : 1

  name   = "${var.name}-rds-parameter-group"
  family = "${var.engine}${substr(var.engine_version, 0, 2)}"

  parameter {
    name  = "max_connections"
    value = var.max_connections
  }

  parameter {
    name  = "log_statement"
    value = var.log_statement
  }

  parameter {
    name  = "work_mem"
    value = var.work_mem
  }

  tags = var.tags
}

resource "aws_rds_cluster_parameter_group" "aurora" {
  count = var.use_aurora ? 1 : 0

  name   = "${var.name}-aurora-parameter-group"
  family = "${var.engine}${substr(var.engine_version, 0, 2)}"

  parameter {
    name  = "max_connections"
    value = var.max_connections
  }

  parameter {
    name  = "log_statement"
    value = var.log_statement
  }

  parameter {
    name  = "work_mem"
    value = var.work_mem
  }

  tags = var.tags
}
