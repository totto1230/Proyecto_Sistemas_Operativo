 #! /bin/bash
 RED='\033[0;31m'
 BLUE='\033[0;34m'
 NC='\033[0m' # No Color
 GREEN='\033[0;32m'
Yellow='\033[0;33m'

 #Check performance
  time_total=$(curl -w "@curl-format.txt" -o /dev/null -s http://sistemasoperativos.com/sistemas | grep -i total | awk '{print $2}' &)
  app_name=$(curl --head http://sistemasoperativos.com/sistemas | grep -i name)
  pod_stats=$(kubectl top pod -n operativos)
  node_stats=$(kubectl top nodes)

function calculateAverage1 () {
    i=0
    time1=0
    while [ $i -lt 15 ]; do
        time_total1=$(curl -w "@curl-format.txt" -o /dev/null -s http://sistemasoperativos.com/sistemas | grep -i total | awk '{print $2}' &)
        time1=$( echo "scale=6; $time1 + $time_total1" | bc )
        i=$(( i + 1 ))
    done
    time_total_average1=$(echo "scale=6; $time1 / 15" | bc)
}

function calculateAverage2 () {
    j=0
    time2=0
    while [ $j -lt 15 ]; do
        time_total2=$(curl -w "@curl-format.txt" -o /dev/null -s http://sistemasoperativos.com/operativos | grep -i total | awk '{print $2}' &)
        time2=$( echo "scale=6; $time2 + $time_total2" | bc )
        j=$(( j + 1 ))
    done
    time_total_average2=$(echo "scale=6; $time2 / 15" | bc)
}



function createFile (){
    calculateAverage1
    calculateAverage2
    printf " \n ${GREEN}------------------------------------------------------------------------\n 
    ${BLUE} `date` ${RED} Nombre de la aplicación: ${NC} $app_name \n 
    ${BLUE} `date` ${RED} Tiempo promedio que toma el servidor en responder 1 requests: ${NC} $time_total 
    ${BLUE} `date` ${RED} Tiempo promedio que toma el servidor en responder 15 requests ${Yellow}/sistemas: ${NC} 0$time_total_average1
    ${BLUE} `date` ${RED} Tiempo promedio que toma el servidor en responder 15 requests ${Yellow}/operativos: ${NC} 0$time_total_average2 \n 
    ${BLUE} `date` ${RED} Métricas de los pods: \n ${NC} \n $pod_stats \n 
    ${BLUE} `date` ${RED}Metricas del nodo:\n ${NC} %s\n" "$node_stats " >> /Users/josephgranados/Desktop/LABS/U/proyecto_operativos/log/performance.log
}


function printInfo (){   
  createFile
  echo "\n--------------------------------------------------- \n"
  printf "${RED} Nombre de la aplicación: ${NC} $app_name \n"
  echo "\n--------------------------------------------------- \n"
  printf "${RED} Tiempo promedio que toma el servidor en responder 1 requests: ${NC} $time_total \n"
  echo "\n--------------------------------------------------- \n"
  printf "${RED} Tiempo promedio que toma el servidor en responder 15 requests ${Yellow}/sistemas: ${NC} 0$time_total_average1 \n"
  printf "${RED} Tiempo promedio que toma el servidor en responder 15 requests ${Yellow}/operativos: ${NC} 0$time_total_average2 \n"
  echo  "\n---------------------------------------------------\n"
  printf "${RED} Métricas de los pods: \n ${NC} \n $pod_stats \n"
  echo  "\n---------------------------------------------------\n"
  printf "${RED}Metricas del nodo:\n ${NC} %s\n" "$node_stats"
  echo "\n---------------------------------------------------\n"
  
}

printInfo