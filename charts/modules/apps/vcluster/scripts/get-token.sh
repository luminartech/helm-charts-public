#!/bin/sh
set -euo pipefail
VCLUSTER_CMD="vcluster connect ${RELEASE_NAME} \
    --insecure \
    --server ${VCLUSTER_SERVER} \
    --service-account=kube-system/developer \
    --cluster-role=cluster-admin \
    --update-current=false"
echo "INFO: Waiting for vcluster to become available"
exitCode=1
count=0
while [ "$exitCode" != "0" ]; do
    (count=count+1)
    echo "      try #${count}"
    set +e
    # vcluster waits for the cluster to come up but times out after some X seconds
    ${VCLUSTER_CMD} -- kubectl -n kube-system get secrets argocd-manager-token
    exitCode=$?
    set -e
    if [ "$count" = "20" ]; then
        echo "ERR: Maximum number of tries exceeded"
        exit 1
    fi
done
echo "INFO: Fetching argo cd sa token from the vcluster"
ARGO_CD_SA_TOKEN=$(
    ${VCLUSTER_CMD} \
        -- kubectl -n kube-system get secrets argocd-manager-token -o yaml |
        grep 'token:' |
        awk -F '[: ]' '{print $5}' |
        base64 -d
)
echo "INFO: Creating new secret to hold the argo cd sa bearer token for external secrets"
kubectl create secret generic "vc-${RELEASE_NAME}-argo-cd-sa-token" \
    --from-literal=bearerToken=${ARGO_CD_SA_TOKEN} --dry-run=client -o yaml >/tmp/secret.yaml
kubectl apply -f /tmp/secret.yaml
