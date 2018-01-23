# Replicas Lab

## Code challenge

Using the documentation at https://v1-8.docs.kubernetes.io/docs/concepts/workloads/controllers/replicaset/, create a replicas resource that encapsulates the information from api-pod.yaml.

For the solution, see the `templates/api-replicaset.yaml`.

To deploy:

    kubectl create -f templates/api-replicaset.yaml

To verify

    kubectl get replicasets
    kubectl get pods

Notice that the name of the pods is different for those that were created by the ReplicaSet.

    kubectl get pod api-replicaset-<HASH> --template='{{(index (index .metadata.annotations))}}{{"\n"}}'
