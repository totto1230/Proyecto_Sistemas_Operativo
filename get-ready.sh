#Abrimos la aplicación de DockerDesktop
open -a Docker
#Verificamos si está corriendo
docker ps
good=$(echo $?)

while [ $good -ne 0 ]; do
     docker ps &> /dev/null
     good=$(echo $?)
done

#Una vez docker est� corriendo, iniciamos Minikube
minikube start
minikube tunnel
