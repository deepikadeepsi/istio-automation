provider "kubernetes" {
  config_path    = var.kubeconfig_path
  config_context = var.kubernetes_context
}

provider "helm" {
  kubernetes {
    config_path    = var.kubeconfig_path
    config_context = var.kubernetes_context
  }
}

# Create Istio namespace
resource "kubernetes_namespace" "istio" {
  metadata {
    name = var.istio_namespace
  }
}

# Deploy Istio Base
resource "helm_release" "istio_base" {
  name       = "istio-base"
  chart      = "base"
  repository = "https://istio-release.storage.googleapis.com/charts"
  version    = var.istio_version
  namespace  = var.istio_namespace
}

# Deploy Istiod (control plane)
resource "helm_release" "istiod" {
  name       = "istiod"
  chart      = "istiod"
  repository = "https://istio-release.storage.googleapis.com/charts"
  version    = var.istio_version
  namespace  = var.istio_namespace
  depends_on = [helm_release.istio_base]

  values = [
    yamlencode({
      resources = {
        requests = {
          cpu    = var.istiod_cpu_request
          memory = var.istiod_memory_request
        }
        limits = {
          cpu    = var.istiod_cpu_limit
          memory = var.istiod_memory_limit
        }
      }
    })
  ]
}

# Deploy Istio Ingress Gateway
resource "helm_release" "istio_ingress_gateway" {
  name       = "istio-ingress"
  chart      = "gateway"
  repository = "https://istio-release.storage.googleapis.com/charts"
  version    = var.istio_version
  namespace  = var.istio_namespace
  depends_on = [helm_release.istiod]

  values = [
    yamlencode({
      service = {
        type = var.ingress_service_type
      }
      resources = {
        requests = {
          cpu    = var.ingress_cpu_request
          memory = var.ingress_memory_request
        }
        limits = {
          cpu    = var.ingress_cpu_limit
          memory = var.ingress_memory_limit
        }
      }
      autoscaling = {
        enabled = false
        minReplicas = var.ingress_replicas
        maxReplicas = var.ingress_replicas
      }
    })
  ]
}

# Create Bookinfo namespace with Istio injection
resource "kubernetes_namespace" "bookinfo" {
  metadata {
    name = var.bookinfo_namespace
    labels = {
      "istio-injection" = "enabled"
    }
  }
}

# Deploy Bookinfo App from raw YAML (apply YAML manifests)

resource "kubernetes_manifest" "bookinfo_app" {
  manifest = yamldecode(file("${path.module}/manifests/bookinfo.yaml"))
  depends_on = [helm_release.istio_ingress_gateway]
}

# Deploy Gateway and VirtualService
resource "kubernetes_manifest" "bookinfo_gateway" {
  manifest = yamldecode(file("${path.module}/manifests/bookinfo-gateway.yaml"))
  depends_on = [kubernetes_manifest.bookinfo_app]
}

# Output ingress IP
data "kubernetes_service" "istio_ingress" {
  metadata {
    name      = "istio-ingress"
    namespace = var.istio_namespace
  }

  depends_on = [helm_release.istio_ingress_gateway]
}
