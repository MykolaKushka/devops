variable "namespace" {
  type    = string
  default = "jenkins"
}

variable "chart_version" {
  type    = string
  default = "5.4.0"
}

variable "values" {
  type = string
  description = "Raw YAML string for Helm values"
}
