TAG=${1:-'latest'}
while :
do
	kubectl describe pod "${TAG}"
	echo "##################################################################"
	echo "##################################################################"
	kubectl get pod "${TAG}"
	sleep 5
	clear
done
