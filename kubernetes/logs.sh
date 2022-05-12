TAG=${1:-'latest'}
kubectl logs "${TAG}" --follow
