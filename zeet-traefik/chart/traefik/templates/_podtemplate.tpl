{{- define "traefik.podTemplate" }}
    metadata:
      annotations:
        prometheus.io/scrape: "true"
        prometheus.io/path: "/metrics"
        prometheus.io/port: "9100"
      labels:
        app.kubernetes.io/name: {{ template "traefik.name" . }}
        helm.sh/chart: {{ template "traefik.chart" . }}
        app.kubernetes.io/managed-by: {{ .Release.Service }}
        app.kubernetes.io/instance: {{ .Release.Name }}
        firewall.coreweave.cloud/allow-all: "true"
    spec:
      imagePullSecrets: [] 
      serviceAccountName: {{ include "traefik.serviceAccountName" . }}
      terminationGracePeriodSeconds: 60
      hostNetwork: false 
      containers:
      - image: "traefik:2.2.11"
        imagePullPolicy: IfNotPresent
        name: {{ template "traefik.fullname" . }}
        resources:
          requests:
            cpu: {{ .Values.resources.requests.cpu | quote }}
            memory: {{ .Values.resources.requests.memory | quote }}
          limits:
            cpu: {{ .Values.resources.limits.cpu | quote }}
            memory: {{ .Values.resources.limits.memory | quote }}
        readinessProbe:
          httpGet:
            path: /ping
            port: {{ .Values.ports.traefik.container }}
          failureThreshold: 1
          initialDelaySeconds: 10
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 2
        livenessProbe:
          httpGet:
            path: /ping
            port: {{ .Values.ports.traefik.container }}
          failureThreshold: 3
          initialDelaySeconds: 10
          periodSeconds: 10
          successThreshold: 1
          timeoutSeconds: 2
        ports:
        - name: "traefik" 
          containerPort: {{ .Values.ports.traefik.container }}
          protocol: TCP
        - name: "web"
          containerPort: {{ .Values.ports.web.container }}
          protocol: TCP
        - name: "websecure" 
          containerPort: {{ .Values.ports.websecure.container }}
          protocol: TCP 
        - name: "metrics" 
          containerPort: {{.Values.ports.metrics.container }}
          protocol: TCP 
        securityContext:
          capabilities:
            drop: [ALL]
          readOnlyRootFilesystem: true
          runAsGroup: 65532
          runAsNonRoot: true
          runAsUser: 65532
        args:
          - "--global.checknewversion"
          - "--global.sendanonymoususage"
          - "--entrypoints.metrics.address=:{{ .Values.ports.metrics.container }}/tcp"
          - "--entrypoints.traefik.address=:{{ .Values.ports.traefik.container }}/tcp"
          - "--entrypoints.websecure.address=:{{ .Values.ports.websecure.container }}/tcp"
          - "--entrypoints.web.address=:{{ .Values.ports.web.container }}/tcp"
          - "--api.dashboard={{ .Values.dashboard.enabled }}"
          - "--api.insecure={{ .Values.dashboard.insecure }}"
          - "--ping=true"
          - "--metrics.prometheus=true"
          - "--metrics.prometheus.entrypoint=metrics"
          - "--providers.kubernetescrd"
          - "--providers.kubernetesingress"
          - "--providers.kubernetescrd.namespaces={{ .Release.Namespace }}"
          - "--providers.kubernetesingress.namespaces={{ .Release.Namespace }}"
          - "--entrypoints.websecure.http.tls=true"
          {{- with .Values.logs }}
          {{- if .general.format }}
          - "--log.format={{ .general.format }}"
          {{- end }}
          {{- if ne .general.level "ERROR" }}
          - "--log.level={{ .general.level | upper }}"
          {{- end }}
          {{- if .access.enabled }}
          - "--accesslog=true"
          {{- if .access.format }}
          - "--accesslog.format={{ .access.format }}"
          {{- end }}
          {{- if .access.bufferingsize }}
          - "--accesslog.bufferingsize={{ .access.bufferingsize }}"
          {{- end }}
          {{- if .access.filters }}
          {{- if .access.filters.statuscodes }}
          - "--accesslog.filters.statuscodes={{ .access.filters.statuscodes }}"
          {{- end }}
          {{- if .access.filters.retryattempts }}
          - "--accesslog.filters.retryattempts"
          {{- end }}
          {{- if .access.filters.minduration }}
          - "--accesslog.filters.minduration={{ .access.filters.minduration }}"
          {{- end }}
          {{- end }}
          - "--accesslog.fields.defaultmode=keep"
          - "--accesslog.fields.headers.defaultmode=drop"
          {{- end }}
          {{- end }}
          - "--providers.kubernetesingress.ingressclass={{ include "traefik.controllerClass" . }}"
          - "--providers.kubernetesingress.namespaces={{ .Release.Namespace }}"
      affinity:
        nodeAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            nodeSelectorTerms:
              - matchExpressions:
                  - key: topology.kubernetes.io/region
                    operator: In
                    values:
                      - {{ .Values.region }}
                  - key: node.coreweave.cloud/class
                    operator: In
                    values:
                      - cpu
        podAntiAffinity:
          requiredDuringSchedulingIgnoredDuringExecution:
            - labelSelector:
                matchExpressions:
                  - key: app.kubernetes.io/instance
                    operator: In
                    values:
                      - {{ .Release.Name }}
              topologyKey: topology.kubernetes.io/zone
      tolerations:
        - key: is_cpu_compute 
          operator: Exists 
      securityContext:
        fsGroup: 65532
{{ end -}}
