#! /bin/bash

# ft_container :
#	[$1] : container name
ft_container()
{
	docker build -t services/$1 image/$1/ #&> /dev/null
	sleep 1
}

# ft_service :
#	[$1] : service name
ft_service()
{
	kubectl apply -f kubernetes/$1-service.yaml #&> /dev/null
    kubectl apply -f kubernetes/$1-deployment.yaml #&> /dev/null
	sleep 1
}

#start docker
echo "N" | bash init_docker.sh
#enlever minikube si il existe deja
#minikube delete
#start minikube avec 4cpu et virtualbox en driver, v=7 pour verbose les infos et erreurs
minikube start --v=7 --cpus 4 --memory 8192 --vm-driver=virtualbox --extra-config=apiserver.service-node-port-range=1-35000

#Mettre l' IP dans les fichiers de configs (creation de .bak)
server_ip=`minikube ip`
sed -i.bak 's/http:\/\/IP/http:\/\/'"$server_ip"'/g' image/mysql/wp.sql
sleep 1
sed -i.bak 's/http:\/\/IP/http:\/\/'"$server_ip"'/g' image/wordpress/wp-config.php
sleep 1

#Mettre a jour la grafana db
#echo "UPDATE data_source SET url = 'http://$server_ip:8086'" | sqlite3 image/grafana/grafana.db

#Ouvrir les ports
#minikube ssh "sudo -u root awk 'NR==14{print \"    - --service-node-port-range=1-35000\"}7' /etc/kubernetes/manifests/kube-apiserver.yaml >> tmp && sudo -u root rm /etc/kubernetes/manifests/kube-apiserver.yaml && sudo -u root mv tmp /etc/kubernetes/manifests/kube-apiserver.yaml"

#Link docker local image to minikube
eval $(minikube docker-env)
sed -i.bak 's/MINIKUBE_IP/'"$server_ip"'/g' image/ftps/start_ftps.sh

#Faire toutes les images et apply dans kubernetes
names="nginx influxdb grafana mysql phpmyadmin wordpress ftps"
for name in $names
do
	ft_container $name
	ft_service $name
	echo -ne "\033[1;33m+>\033[0;33m Service $name fait.\n"
done;

#activer le ingress controler
minikube addons enable ingress

echo -ne "\033[1;33m+>\033[0;33m IP : $server_ip \n"

sleep 1
sed -i.bak 's/http:\/\/'"$server_ip"'/http:\/\/IP/g' image/mysql/wp.sql
sleep 1
sed -i.bak 's/http:\/\/'"$server_ip"'/http:\/\/IP/g' image/wordpress/wp-config.php
sleep 1
sed -i.bak 's/'"$server_ip"'/MINIKUBE_IP/g' image/ftps/start_ftps.sh
sleep 1

#Waiting for the site to be up
until $(curl --output /dev/null --silent --head --fail http://$server_ip/); do
	echo -n "."
	sleep 2
done;

echo -ne " Open website ... \n"
open http://$server_ip

### Dashboard
# minikube dashboard

### Crash Container
# kubectl exec -it $(kubectl get pods | grep mysql | cut -d" " -f1) -- /bin/sh -c "ps"  
# kubectl exec -it $(kubectl get pods | grep mysql | cut -d" " -f1) -- /bin/sh -c "kill number" 