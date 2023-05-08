# How to enable custom domain

1. Install Traefik LB
    ##### Using Zeet
  
    install traefik on zeet using the official Blueprint
  
    https://zeet.co/new/zeet/traefik-coreweave

    input traefik.yaml in the values

    ##### Using Coreweave Apps

    Install traefik on apps.coreweave.com using traefik.yaml config

2. Install Cert and Middleware
    ##### Using Zeet
   
    install traefik config using the official Blueprint
     
    https://zeet.co/new/zeet/traefik-config-coreweave

    ##### Using kubectl
    
    Clone this git repository and navigate into the zeet-traefik folder
  
    `kubectl apply -f cert.yaml`
