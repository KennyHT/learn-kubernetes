#!/usr/bin/env bash

K8S_DASHBOARD_PORT=30000

k8s-dashboard-up () {
    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

    until kubectl get pods --namespace=kube-system | grep kubernetes-dashboard &> /dev/null
	    do
	        sleep 1
        done

    kube_dashboard_name=$(kubectl get pods --namespace=kube-system | grep kubernetes-dashboard | awk '{print $1}')

    until [ "true" == "$(kubectl get pod --namespace=kube-system ${kube_dashboard_name} -o json | jq -r .status.containerStatuses[0].ready)" ]
	    do
	        sleep 1
        done

    nohup kubectl port-forward ${kube_dashboard_name} ${K8S_DASHBOARD_PORT}:8443 --namespace=kube-system &> /dev/null &

    echo "[info]: Kubernetes dashboard available at https://localhost:${K8S_DASHBOARD_PORT}"
}

k8s-dashboard-down() {
    kubectl delete -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml
    kill $(lsof -nP -i tcp:${K8S_DASHBOARD_PORT} | grep LISTEN | awk '{print $2}')
}

$*
