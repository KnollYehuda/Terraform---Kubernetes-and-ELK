TAG=${1:-'latest'}
kubectl exec --stdin --tty "${TAG}" -- /bin/bash
