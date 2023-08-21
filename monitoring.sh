#! /bin/bash

#Codigo colores para la terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
Yellow='\033[0;33m'
NC='\033[0m' # No Color
i=0

#Ver si la app está bien
ping -c 1 sistemasoperativos.com &> /dev/null
result1=$(echo $?)
if [ $result1 -eq 0 ]; then
   sistemas=$(curl -Is http://sistemasoperativos.com/sistemas | awk '{print $2}' | head -1 )
   operativos=$(curl -Is http://sistemasoperativos.com/operativos | awk '{print $2}' | head -1 )
   if [ $sistemas -ne 200 ] || [ $operativos -ne 200 ]; then
      printf "${BLUE} `date` ${Yellow} - ${RED} LA APLICACIÓN ESTÁ PARCIALMENTE CAÍDA, REVISAR CLUSTER URGENTEMENTE \n" | tee -a /Users/josephgranados/Desktop/LABS/U/proyecto_operativos/log/monitor.log
      #Identify which one is failing
      if [ $sistemas -ne 200 ]; then
         #Find whats failing
         if [ $sistemas -ge 400 ] && [ $sistemas -lt 499 ]; then
            printf "${BLUE} `date` ${Yellow} - ${RED} SISTEMAS ESTÁ RETORNANDO CLIENT ERROR RESPONSE (400 - 499) , REVISAR CLUSTER URGENTEMENTE\n" | tee -a /Users/josephgranados/Desktop/LABS/U/proyecto_operativos/log/monitor.log
            #SEND EMAIL SISTEMAS IS RETURNING A CLIENT ERROR RESPONSE
         elif [ $sistemas -ge 500 ] && [ $sistemas -lt 599 ]; then
            printf "${BLUE} `date` ${Yellow} - ${RED} SISTEMAS ESTÁ RETORNANDO A SERVER ERROR RESPONSE (500 - 599) , REVISAR CLUSTER URGENTEMENTE\n" | tee -a /Users/josephgranados/Desktop/LABS/U/proyecto_operativos/log/monitor.log
            #SEND EMAIL SISTEMAS IS RETURNING A server ERROR RESPONSE
         fi
      fi
      if [ $operativos -ne 200 ]; then
         #Find whats failing
         if [ $operativos -ge 400 ] && [ $operativos -lt 499 ]; then
            printf "${BLUE} `date` ${Yellow} - ${RED} OPERATIVOS ESTÁ RETORNANDO CLIENT ERROR RESPONSE (400 - 499) , REVISAR CLUSTER URGENTEMENTE\n" | tee -a /Users/josephgranados/Desktop/LABS/U/proyecto_operativos/log/monitor.log
            #SEND EMAIL operativos IS RETURNING A CLIENT ERROR RESPONSE
         elif [ $operativos -gt 500 ] && [ $operativos -lt 599 ]; then
            printf "${BLUE} `date` ${Yellow} - ${RED} OPERATIVOS ESTÁ RETORNANDO A SERVER ERROR RESPONSE (500 - 599) , REVISAR CLUSTER URGENTEMENTE\n"| tee -a /Users/josephgranados/Desktop/LABS/U/proyecto_operativos/log/monitor.log
            #SEND EMAIL operativos IS RETURNING A server ERROR RESPONSE
         fi
      fi
   else
      printf "\n ${BLUE} `date` ${Yellow} - ${GREEN} TODO ESTÁ CORRIENDO BIEN\n" | tee -a /Users/josephgranados/Desktop/LABS/U/proyecto_operativos/log/monitor.log
   fi
else
   printf "\n${BLUE} `date` ${Yellow} - ${RED} LA APLICACIÓN ESTÁ CAÍDA, REVISAR CLUSTER URGENTEMENTE\n" | tee -a /Users/josephgranados/Desktop/LABS/U/proyecto_operativos/log/monitor.log
fi
