REGION=${1:-'NA'}
CLUSTER_NAME=${2:-'NA'}
REDIS_ENDPOINT=${3:-'NA'}

efs_id=$(aws efs --region $REGION describe-file-systems | jq -r ".FileSystems[] | select(.CreationToken == \"$CLUSTER_NAME\") | .FileSystemId")

echo "============================================="
echo "..:: NAMESPACE ::.."
yq -i ".metadata.name=\"$CLUSTER_NAME-namespace\"" ./kubernetes/namespace.yaml
yq -i ".metadata.labels.name=\"$CLUSTER_NAME-namespace\"" ./kubernetes/namespace.yaml
echo "============================================="

echo "============================================="
echo "..:: SERVER ::.."
yq -i ".metadata.namespace=\"$CLUSTER_NAME-namespace\"" ./kubernetes/server/server-deployment.yaml
echo "============================================="

echo "============================================="
echo "..:: DASHBOARD ::.."
yq -i ".metadata.namespace=\"$CLUSTER_NAME-namespace\"" ./kubernetes/dashboard/dashboard-deployment.yaml
echo "============================================="

echo "============================================="
echo "..:: ENV-CONFIG-MAP ::.."
yq -i ".metadata.namespace=\"$CLUSTER_NAME-namespace\"" ./kubernetes/env-config-map.yaml
yq -i ".data.\"env.global.app_name\"=\"$CLUSTER_NAME\"" ./kubernetes/env-config-map.yaml
echo "============================================="

echo "============================================="
echo "..:: INGRESS ::.."
yq -i ".metadata.namespace=\"$CLUSTER_NAME-namespace\"" ./kubernetes/ingress/ingress-dashboard.yaml
yq -i ".metadata.namespace=\"$CLUSTER_NAME-namespace\"" ./kubernetes/ingress/ingress-server.yaml
yq -i ".spec.tls.0.hosts.0=\"api-$CLUSTER_NAME.change_me.com\"" ./kubernetes/ingress/ingress-server.yaml
yq -i ".spec.rules.0.host=\"api-$CLUSTER_NAME.change_me.com\"" ./kubernetes/ingress/ingress-server.yaml
yq -i ".spec.tls.0.hosts.0=\"$CLUSTER_NAME.change_me.com\"" ./kubernetes/ingress/ingress-dashboard.yaml
yq -i ".spec.rules.0.host=\"$CLUSTER_NAME.change_me.com\"" ./kubernetes/ingress/ingress-dashboard.yaml
echo "============================================="

echo "============================================="
echo "..:: PV ::.."
yq -i ".metadata.namespace=\"$CLUSTER_NAME-namespace\"" ./kubernetes/pv.yaml
yq -i ".spec.csi.volumeHandle=\"$efs_id\"" ./kubernetes/pv.yaml
echo "============================================="

echo "============================================="
echo "..:: PVC ::.."
yq -i ".metadata.namespace=\"$CLUSTER_NAME-namespace\"" ./kubernetes/pvc.yaml
echo "============================================="

echo "============================================="
echo "..:: SECRET-CERT ::.."
yq -i ".metadata.namespace=\"$CLUSTER_NAME-namespace\"" ./kubernetes/secret-cert.yaml
echo "============================================="

echo "============================================="
echo "..:: SECRET-CONTAINER_REGISTRY ::.."
yq -i ".metadata.namespace=\"$CLUSTER_NAME-namespace\"" ./kubernetes/secret-container-registry.yaml
echo "============================================="

echo "============================================="
echo "..:: STORAGE-CLASS ::.."
yq -i ".metadata.namespace=\"$CLUSTER_NAME-namespace\"" ./kubernetes/storageclass.yaml
echo "============================================="

aws eks --region $REGION update-kubeconfig --name $CLUSTER_NAME
echo "setting namespace :: $CLUSTER_NAME-namespace"
kubectl apply -f ./kubernetes/namespace.yaml

kubectl config set-context --current --namespace="$CLUSTER_NAME-namespace"

aws iam create-policy \
    --policy-name AmazonEKS_EFS_CSI_Driver_Policy_$CLUSTER_NAME \
    --policy-document file://kubernetes/iam-policy-example.json

eksctl create iamserviceaccount \
    --cluster $CLUSTER_NAME \
    --namespace kube-system \
    --name efs-csi-controller-sa \
    --attach-policy-arn arn:aws:iam::000000000000:policy/AmazonEKS_EFS_CSI_Driver_Policy_$CLUSTER_NAME \
    --approve \
    --region $REGION

eksctl utils associate-iam-oidc-provider --region=$REGION --cluster=$CLUSTER_NAME
kubectl kustomize \
    "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/ecr?ref=release-1.3" > ./kubernetes/private-ecr-driver.yaml

sed -i.bak -e "s|us-west-2|$REGION|" ./kubernetes/private-ecr-driver.yaml
sed -i.bak -e "s|602401143452|$(python3 ./kubernetes/container_image_address.py $REGION)|" ./kubernetes/private-ecr-driver.yaml
kubectl apply -f ./kubernetes/private-ecr-driver.yaml

kubectl apply -f ./kubernetes/secret-cert.yaml
kubectl apply -f ./kubernetes/secret-container-registry.yaml
kubectl apply -f ./kubernetes/csi-driver.yaml
kubectl apply -f ./kubernetes/pv.yaml
kubectl apply -f ./kubernetes/pvc.yaml
kubectl apply -f ./kubernetes/storageclass.yaml
kubectl apply -f ./kubernetes/env-config-map.yaml
kubectl apply -f ./kubernetes/server/server-deployment.yaml
kubectl apply -f ./kubernetes/server/server-service.yaml
kubectl apply -f ./kubernetes/dashboard/dashboard-deployment.yaml
kubectl apply -f ./kubernetes/dashboard/dashboard-service.yaml
kubectl apply -f ./kubernetes/ingress/ingress-dashboard.yaml
kubectl apply -f ./kubernetes/ingress/ingress-server.yaml
kubectl apply -f ./kubernetes/celery.yaml
kubectl apply -f ./kubernetes/beat.yaml
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.2.0/deploy/static/provider/aws/deploy.yaml
