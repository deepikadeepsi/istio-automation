output "ingress_gateway_ip" {
  value       = data.kubernetes_service.istio_ingress.status.load_balancer[0].ingress[0].ip
  description = "The external IP of the Istio ingress gateway."
}
