REGION=${1:-'NA'}
CLUSTER=${2:-'NA'}

if [[ "$REGION" == "NA" ]]; then
  echo 'REGION invalid'
fi

if [[ "$CLUSTER" == "NA" ]]; then
  echo 'CLUSTER invalid'
fi

echo 'connecting to AWS kubernetes service...'
aws eks --region $REGION update-kubeconfig --name $CLUSTER
