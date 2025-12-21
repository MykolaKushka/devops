#######################################
# Aurora Cluster
#######################################

resource "aws_rds_cluster" "this" {
  count = var.use_aurora ? 1 : 0

  cluster_identifier = "${var.name}-aurora-cluster"

  engine         = var.engine
  engine_version = var.engine_version

  database_name   = var.db_name
  master_username = var.username
  master_password = var.password
  port            = var.port

  db_subnet_group_name   = aws_db_subnet_group.this.name
  vpc_security_group_ids = [aws_security_group.this.id]

  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.aurora[0].name

  backup_retention_period = var.backup_retention_period
  skip_final_snapshot     = var.skip_final_snapshot

  tags = merge(
    {
      Name = "${var.name}-aurora-cluster"
    },
    var.tags
  )

  depends_on = [
    aws_db_subnet_group.this,
    aws_security_group.this
  ]
}

#######################################
# Aurora Cluster Instances
#######################################

resource "aws_rds_cluster_instance" "this" {
  count = var.use_aurora ? var.cluster_instances : 0

  identifier = "${var.name}-aurora-${count.index}"

  cluster_identifier = aws_rds_cluster.this[0].id

  instance_class = var.instance_class
  engine         = var.engine
  engine_version = var.engine_version

  publicly_accessible = var.publicly_accessible

  tags = merge(
    {
      Name = "${var.name}-aurora-${count.index}"
    },
    var.tags
  )
}
