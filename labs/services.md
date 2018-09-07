# Services Lab

To illustrate the dynamic and loosely coupled design of Kubernetes, we're going to expose a service, but exposing the service first without any pods to support it.

!!! note

    Because Docker for Desktop does not bind the `NodePort` associated with the `LoadBalancer` Service type to localhost (on the host), I will be using the a type of `NodePort` service.

    Currently when using type `LoadBalancer`, every `port` value (not the NodePort) in our service is mapped from our host machine to the Docker VM. I have no idea why this is the default as it means that we can't have multiple services which listen on the same ports.

Create the service:

    kubectl apply -f manifests/service.yaml

Inspect the service so we can get the randomly assigned ports:

    kubectl describe service kuard-service | grep Port

Confirm we don't have any pods matching the label the service is querying for:

    kubectl get pods kuard-pod

Then open a new terminal window and create the kuard pod.

    kubectl apply -f manifests/pod.yaml

### Service name by DNS

This must be done through a container running in the same namespace as the service.

Now that we've deployed our API pod, we can get the FQDN.

    debug-container-up
    nslookup kuard-service

### The ClusterIP

When a Service is created, it is assigned Cluster IP which is unique for the life of the service. This Service IP is completely virtual though. See https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies for more info.

Let's find the `Cluster IP` value of the `kuard-service`. The Cluster IP is guaranteed not to change.

    echo `kubectl get service kuard-service --template='{{.spec.clusterIP}}'`
    
    
Let's verify that this is a legit IP address by hitting it from the Docker VM.

    kubectl describe service kuard-service
    make docker-vm-shell
    ping <ip address>

<!--
### TODO

 - Example of hitting the service hostname.
 - Clarify that "nslookup: can't resolve '(null)': Name does not resolve" is expected because there is no DNS to perform the lookup against.
 -->