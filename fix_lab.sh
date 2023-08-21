#! /bin/bash
kubectl scale deploy --replicas=2 -n operativos operativos
kubectl scale deploy --replicas=2 -n operativos sistemas
kubectl scale deploy --replicas=2 -n operativos sistemas && kubectl scale deploy --replicas=2 -n operativos sistemas
kubectl apply -f /Users/josephgranados/Desktop/LABS/U/proyecto_operativos/ingress_files/ingress

