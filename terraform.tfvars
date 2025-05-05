kubeconfig_path    = "~/.kube/config"
kubernetes_context = "istio"

istio_namespace = "istio-system"
istio_version   = "1.19.0"

istiod_cpu_request    = "500m"
istiod_memory_request = "2Gi"
istiod_cpu_limit      = "1000m"
istiod_memory_limit   = "4Gi"

ingress_service_type    = "LoadBalancer"
ingress_cpu_request     = "100m"
ingress_memory_request  = "128Mi"
ingress_cpu_limit       = "2000m"
ingress_memory_limit    = "1024Mi"
ingress_replicas        = 2

bookinfo_namespace = "bookinfo"
