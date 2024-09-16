helm repo add prometheus-community https://prometheus-community.github.io/helm-charts &&
helm repo update &&
helm upgrade --install --atomic --timeout 300s kps prometheus-community/kube-prometheus-stack \
  -n monitoring  --create-namespace --timeout 300s --values - <<EOF

grafana:
  adminPassword: "admin"
  persistence:
    enabled: true

prometheus:
  prometheusSpec:
    podMonitorSelector:
      matchLabels:
        kps: "true"
    storageSpec:
     volumeClaimTemplate:
       spec:
         accessModes: ["ReadWriteOnce"]
         resources:
           requests:
             storage: 10Gi

#    additionalScrapeConfigs:
#      - job_name: 'kubernetes-pods'
#        kubernetes_sd_configs:
#          - role: pod
#        relabel_configs:
#          - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
#            action: keep
#            regex: true
EOF
sleep 30
kubectl apply -f ../podmonitor.yaml