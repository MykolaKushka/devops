variable "use_aurora" {
  description = "If true - create Aurora Cluster (with writer instance). If false - create single RDS instance"
  type        = bool
  default     = false
}

variable "name" {
  description = "Base name/prefix for DB resources (identifier, subnet group, SG, parameter groups)"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID where DB security group will be created"
  type        = string
}

variable "subnet_ids" {
  description = "Private subnet IDs for DB Subnet Group"
  type        = list(string)
}

variable "allowed_cidrs" {
  description = "CIDR blocks allowed to connect to DB port"
  type        = list(string)
  default     = []
}

variable "engine" {
  description = "Database engine. For RDS: postgres/mysql. For Aurora: aurora-postgresql/aurora-mysql"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Engine version"
  type        = string
  default     = "15.4"
}

variable "instance_class" {
  description = "DB instance class (for RDS instance or Aurora instances)"
  type        = string
  default     = "db.t3.micro"
}

variable "multi_az" {
  description = "Multi-AZ for non-Aurora RDS instance"
  type        = bool
  default     = false
}

variable "db_name" {
  description = "Initial database name"
  type        = string
  default     = "appdb"
}

variable "username" {
  description = "Master username"
  type        = string
  default     = "appuser"
}

variable "password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "port" {
  description = "Database port"
  type        = number
  default     = 5432
}

variable "publicly_accessible" {
  description = "Whether DB should be publicly accessible"
  type        = bool
  default     = false
}

variable "storage_allocated" {
  description = "Allocated storage (GB) for RDS instance (ignored for Aurora)"
  type        = number
  default     = 20
}

variable "storage_type" {
  description = "Storage type for RDS instance (gp2/gp3/io1)"
  type        = string
  default     = "gp3"
}

variable "backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
  default     = 7
}

variable "skip_final_snapshot" {
  description = "Skip final snapshot on destroy"
  type        = bool
  default     = true
}

variable "cluster_instances" {
  description = "Number of Aurora DB cluster instances (at least 1 writer)"
  type        = number
  default     = 1
}

variable "max_connections" {
  description = "Parameter group: max_connections"
  type        = string
  default     = "200"
}

variable "log_statement" {
  description = "Parameter group: log_statement (PostgreSQL)"
  type        = string
  default     = "none"
}

variable "work_mem" {
  description = "Parameter group: work_mem (PostgreSQL)"
  type        = string
  default     = "4096"
}

variable "tags" {
  description = "Common tags for resources"
  type        = map(string)
  default     = {}
}
