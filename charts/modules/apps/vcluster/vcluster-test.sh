#!/bin/bash
CLUSTER_NAME=my-vcluster
CLUSTER_FQDN=${CLUSTER_NAME}.dev.domain.com
VALUES_FILE=/tmp/${CLUSTER_NAME}-values.$$.yaml

cat >${VALUES_FILE} <<EOF
syncer:
  kubeConfigContextName: ${CLUSTER_NAME}
  extraArgs:
  - --tls-san=${CLUSTER_FQDN}
  - --out-kube-config-server=https://${CLUSTER_FQDN}

vcluster:
  extraArgs:
  - --tls-san=${CLUSTER_FQDN}

init:
  manifestsTemplate: |
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: argocd-manager
      namespace: kube-system
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRole
    metadata:
      name: argocd-manager-role
    rules:
      - apiGroups:
          - '*'
        resources:
          - '*'
        verbs:
          - '*'
      - nonResourceURLs:
          - '*'
        verbs:
          - '*'
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: argocd-manager-role-binding
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: argocd-manager-role
    subjects:
      - kind: ServiceAccount
        name: argocd-manager
        namespace: kube-system
    ---
    # This is required only for kubernetes 1.24+
    # https://github.com/argoproj/argo-cd/issues/9610
    apiVersion: v1
    kind: Secret
    metadata:
      name: argocd-manager-token
      namespace: kube-system
      annotations:
        kubernetes.io/service-account.name: argocd-manager
    type: kubernetes.io/service-account-token
    ---
    apiVersion: rbac.authorization.k8s.io/v1
    kind: ClusterRoleBinding
    metadata:
      name: vcluster-sa-developer-kube-system
    roleRef:
      apiGroup: rbac.authorization.k8s.io
      kind: ClusterRole
      name: cluster-admin
    subjects:
    - kind: ServiceAccount
      name: developer
      namespace: kube-system
    ---
    apiVersion: v1
    kind: ServiceAccount
    metadata:
      name: developer
      namespace: kube-system

sync:
  ingresses:
    enabled: true
  hoststorageclasses:
    enabled: true

storage:
  persistence: false

replicas: 1

isolation:
  networkPolicy:
    enabled: "false"

multiNamespaceMode:
  enabled: false

ingress:
  enabled: true
  ingressClassName: nginx-ingress-internal
  host: "${CLUSTER_FQDN}"
  annotations:
    nginx.ingress.kubernetes.io/backend-protocol: "HTTPS"
    nginx.ingress.kubernetes.io/ssl-redirect: "true"
    nginx.ingress.kubernetes.io/ssl-passthrough: "true"
    kubernetes.io/ingress.allow-http: "false"

EOF

vcluster create ${CLUSTER_NAME} \
    --namespace test-${CLUSTER_NAME} \
    --create-namespace=true \
    --connect=false \
    --expose-local=false \
    --extra-values=${VALUES_FILE}

echo vcluster connect ${CLUSTER_NAME} \
    --namespace test-${CLUSTER_NAME} \
    --server https://${CLUSTER_FQDN} \
    --kube-config-context-name=${CLUSTER_NAME} \
    --kube-config=./${CLUSTER_NAME}.yaml \
    --service-account=kube-system/developer \
    --cluster-role=cluster-admin
