apiVersion: cert-manager.io/v1
kind: ClusterIssuer
metadata:
  name: ${name}
spec:
  acme:
    email: ${email}
    privateKeySecretRef:
      name: gclouddnsissuersecret
    server: https://acme-staging-v02.api.letsencrypt.org/directory 
    solvers:
      - dns01:
          cloudDNS:
            project: ${gcp_project}