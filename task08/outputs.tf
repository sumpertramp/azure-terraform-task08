output "aci_fqdn" {
  value = module.aci.fqdn
}


output "aks_lb_ip" {
  value = try(data.kubernetes_service.app_svc.status[0].load_balancer[0].ingress[0].ip, null)
  description = "Public IP of the K8S LoadBalancer"
}
