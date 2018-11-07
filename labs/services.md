# Services Lab

To illustrate the dynamic nature of Kubernetes Services and Pods, we're going to expose a service, but first exposing the Service without any Pods.

Let's make sure we don't have any Podsby running:

    kubectl delete pods --all --namespace=learn-k8s

Create the Service:

    kubectl apply -f manifests/service.yaml

Inspect the service so we can get the randomly assigned node ports. Note that each port for our service has been assigned a node port:

    kubectl describe service kuard | grep Port

A Service defines the interface to which requests are made. Regardless of the ports that the containers in a Pod may expose, it is the ports mapped at the Service level that are used.

Confirm we don't have any Pods matching the label the service is querying for:

    kubectl get pods --selector=app=kuard

We can determine the Service doesn't have associated Pods because there are no endpoints associated with the Service.

    kubectl describe service kuard

Let's create the kuard Pod again.

    kubectl apply -f manifests/pod.yaml

Watch to see that the Pod is ready:

    watch kubectl get pods

Once it is, you can now see one endpoint.

    kubectl describe service kuard

### Service name by DNS

This must be done through a container running in the same namespace as the service.

Now that we've deployed the kuard Pod, we can get the fully qualified domain name (FQDN).

    make debug-container
    nslookup kuard
    nslookup kuard.learn-k8s

!!! note
    The output from `nslookup` which says "nslookup: can't resolve '(null)': Name does not resolve" is expected because there is no DNS server to perform the lookup against.

Now let's try making a request to the service.

    wget kuard -q -O -

What's neat, is that the Service is constantly monitoring the Pods who's labels match its selector query, and so knows, which Pod IP addresses (endpoints) to route the request to.

Exit (to kill) the debug container.

### The ClusterIP

When a Service is created, it is assigned a Cluster IP which is unique and static for the life of the service. The Service IP is completely virtual though. See https://kubernetes.io/docs/concepts/services-networking/service/#virtual-ips-and-service-proxies for more info.

Let's find the `.spec.clusterIP` value of the `kuard`.

    echo $(kubectl get service kuard --template='{{.spec.clusterIP}}')

Let's verify that this is a legit IP address by hitting it from inside our Kubernetes instance.

Docker for Desktop users should run:

    make docker-vm-shell

Now inside the Kubernetes instance, use the IP address you retrieved earlier.

    wget $SERVICE_IP -q -O -

No magic and no hidden IP address schemes. Kubernetes is awesome!

<!-- TODO
 - Creating a Service alias to point to external services (e.g. PostgreSQL instance) outside of the cluster.
 - Ambassador. 
>
