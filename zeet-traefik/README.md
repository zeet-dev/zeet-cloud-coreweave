# How to enable custom domain

1. Install Traefik LB
    ##### Using Zeet
  
    install traefik on zeet using
  
    https://zeet.co/new/helm

    ```
    repo: `http://helm.corp.ingress.ord1.coreweave.com/`
    chart: `traefik`
    ```

    input traefik.yaml in the values

    ##### Using Coreweave Apps

    Install traefik on apps.coreweave.com using traefik.yaml config

2. Install Cert and Middleware
    ##### Using Zeet
    https://zeet.co/new/manifest

    reference raw path

    https://raw.githubusercontent.com/zeet-dev/zeet-cloud-coreweave/main/zeet-traefik/cert.yaml


    ##### Using kubectl
    `kubectl apply -f cert.yaml`
