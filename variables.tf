variable "kubeconfig_path" {
  type        = string
  description = "Path to kubeconfig file"
  default     = "~/.kube/config"
}

variable "kubernetes_context" {
  type        = string
  description = "Kubernetes context to use"
  default     = "istio"
}

variable "istio_namespace" {
  type        = string
  description = "Namespace for Istio components"
  default     = "istio-system"
}

variable "istio_version" {
  type        = string
  description = "Istio version to deploy"
  default     = "1.19.0"
}

variable "istiod_cpu_request" {
  type    = string
  default = "500m"
}

variable "istiod_memory_request" {
  type    = string
  default = "2Gi"
}

variable "istiod_cpu_limit" {
  type    = string
  default = "1000m"
}

variable "istiod_memory_limit" {
  type    = string
  default = "4Gi"
}

variable "ingress_service_type" {
  type    = string
  default = "LoadBalancer"
}

variable "ingress_cpu_request" {
  type    = string
  default = "100m"
}

variable "ingress_memory_request" {
  type    = string
  default = "128Mi"
}

variable "ingress_cpu_limit" {
  type    = string
  default = "2000m"
}

variable "ingress_memory_limit" {
  type    = string
  default = "1024Mi"
}

variable "ingress_replicas" {
  type    = number
  default = 2
}

variable "bookinfo_namespace" {
  type    = string
  default = "bookinfo"
}
