 #! /bin/bash

 #Codigo colores para la terminal
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
Yellow='\033[0;33m'
NC='\033[0m' # No Color

printf "Elige una opcion: \n${NC} 1. Matar ${Yellow}/operativos${RED} \n${NC} 2. Matar ${Yellow} /sistemas${RED} \n ${NC}3. Matar ambos ${RED} \n ${NC}4. Generar ${RED}404 \n:"
read OPTION

case $OPTION in
    1)
        echo "Killed /operativos"
        kubectl scale deploy --replicas=0 -n operativos operativos
        ;;
    2)
        echo "Killed /sistemas"
        kubectl scale deploy --replicas=0 -n operativos sistemas
        ;;
    3)
        echo "Killed both"
        kubectl scale deploy --replicas=0 -n operativos sistemas && kubectl scale deploy --replicas=0 -n operativos operativos
        ;;
    4)
        echo "Broke deployment"
        kubectl apply -f /Users/josephgranados/Desktop/LABS/U/proyecto_operativos/ingress_files/ingressbad.yaml
        ;;
    *)
      echo "INVALID OPTION"
esac
