#! /bin/bash


SERVICE_LIST="mysql phpmyadmin nginx wordpress ftps influxdb grafana"

printf "➜	Cleaning all services...\n"
for SERVICE in $SERVICE_LIST
do
	kubectl delete -f kubernetes/$SERVICE-service.yaml
    kubectl delete -f kubernetes/$SERVICE-deployment.yaml
done
#kubectl delete -f srcs/ingress.yaml > /dev/null
printf "✓	Clean complete !\n"

#enlever minikube si il existe deja
minikube delete

exit