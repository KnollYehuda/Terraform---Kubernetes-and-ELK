kubectl delete deploy server-deployment dashboard-deployment
kubectl apply -f ./kubernetes/server/server-deployment.yaml
kubectl apply -f ./kubernetes/dashboard/dashboard-deployment.yaml
echo 'getting updated k8s pods...'
sleep 5
echo '==========================================================================='
kubectl get pod -o wide
echo '==========================================================================='
