locals {
  values_runner = <<VALUES
imagePullPolicy: IfNotPresent
gitlabUrl: "https://${var.gitlab_fqdn}/"
runnerRegistrationToken: ${var.runner_repo_token}
terminationGracePeriodSeconds: 3600
concurrent: 10
checkInterval: 30
sessionServer:
  enabled: false
rbac:
  create: true
  clusterWideAccess: true
  podSecurityPolicy:
    enabled: false
    resourceNames:
      - gitlab-runner
runners:
  config: |
    [[runners]]
      [runners.kubernetes]
        namespace = "{{.Release.Namespace}}"
        image = "ubuntu:20.04"
        privileged = false
VALUES

  values_agent = <<VALUES
image:
  tag: v16.10.1
config:
  token: ${var.agent_token}
  kasAddress: wss://${var.gitlab_fqdn}/-/kubernetes-agent/
VALUES

  values_ingress-nginx = <<VALUES
controller:
  service:
    annotations:
      yandex.cloud/subnet-id: ${var.subnet_id}
      yandex.cloud/load-balancer-type: internal
    externalTrafficPolicy: "Local"
    loadBalancerIP: ${var.loadbalancer_ip}
VALUES
}

resource "helm_release" "gitlab-runner" {
  name             = "gitlab-runner"
  repository       = "https://charts.gitlab.io"
  namespace        = "gitlab-runner"
  chart            = "gitlab-runner"
  version          = "0.63.0"
  create_namespace = true

  values = [
    local.values_runner
  ]
}

resource "helm_release" "gitlab-agent" {
  name             = "gitlab-agent"
  repository       = "https://charts.gitlab.io"
  namespace        = "gitlab-agent"
  chart            = "gitlab-agent"
  version          = "1.25.0"
  create_namespace = true

  values = [
    local.values_agent
  ]
}

resource "helm_release" "nginx-ingress" {
  name             = "ingress-nginx"
  repository       = "https://kubernetes.github.io/ingress-nginx"
  namespace        = "ingress-nginx"
  chart            = "ingress-nginx"
  version          = "4.10.1"
  create_namespace = true

  values = [
    local.values_ingress-nginx
  ]
  timeout = 600
}