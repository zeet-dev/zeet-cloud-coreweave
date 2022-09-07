# Traefik

**Traefik** is a modern HTTP reverse proxy and load balancer made to deploy microservices with ease. This App creates a Traefik Ingress Controller.

An Ingress controller allows you to expose HTTP based applications without needing to assign a service with a public IP to each application, it also optionally protects your unencrypted applications with TLS encryption.

**You ONLY need to deploy this app to take advantage of custom domains. CoreWeave provides a [shared ingress](https://docs.coreweave.com/coreweave-kubernetes/exposing-applications#ingress) to easily expose applications with a domain ending in `coreweave.cloud` with no setup required.**
***
## Usage

### Region

It is important that you deploy the Ingress Controller in the same region as your workloads

### ControllerClass

Ingress Controller Class is used to specify ingress routes to this ingress controller. By default we name the ingressclass after your namespace and release name. If you plan on deploying multiple custom controllers to a single namespace then you will need to provide a custom name here so that there are no conflicts.

### ExternalDns

By Default we provide an external DNS Entry for your ingress controller, subdomained to your chart release. If you wish to customize your ingress controller subdomain, you can modify the YAML file directly.

### TLS

The ingress supports [TLS Configuration](https://kubernetes.io/docs/concepts/services-networking/ingress/#tls). Certificates can either be provided in a Secret, or [cert-manager](https://cert-manager.io/) can be leveraged to automatically generate or request certificates. cert-manager is already available, and doesn't have to be installed. However, you will need to create an [Issuer](https://cert-manager.io/docs/concepts/issuer/) for your CA / certificate.

***
If you wish to access more settings and configuration values please visit the
[Official Helm Chart](https://github.com/traefik/traefik-helm-chart) and let us know what you require.
