# Services Lab

To illustrate the dynamic and loosely coupled design of Kubernetes, we're going to expose a service, but exposing the service first without any pods to support it.

Create the service:

    kubectl create -f templates/api-service.yaml

Inspect the service so we can get the randomly assigned port:

    kubectl describe service/api-service

What happens when we try to access the service?

    curl http://<MINIKUBE_IP>:<PORT>

Confirm we don't have any pods matching the label the service is querying for:

    kubectl get pods

Minikube has a neat shortcut for launching our service on the correct IP and port. Execute and leave running.

    minikube service api-service

Open a new terminal window and create the api pod.

    kubectl create -f templates/api-pod.yaml

Switch back to the other terminal at which point, it will launch a web browser window when an endpoint becomes available. 
