# Deployments

Create the deployment object:

    kubectl apply -f templates/api-deployments.yaml

Get the state of the deploloyment:

    kubectl get deployments
    kubectl describe deployment api-deployment

## Scale our pods using Deployments

Update `spec.replicas` in `api-deployments.yaml` to be 15, then deploy our changes:

    kubectl apply -f templates/api-deployments.yaml

Then observe the state change to the list of pods every second using the `watch` command:

    watch -n 1 kubectl get pods 

Notice the old pods don't get deleted straight away. This is because of `spec.minReadySeconds` value of 30 seconds.

## Deploy a new version of our API container

Let's change the data in `api/data/users/index.json` to change the data served by our API.

Then lets build a new version of the api container:

    make api-build VERSION=2.0

Now update your `api-deployments.yaml` file, changing the image tag to `2.0` and adding the following under `spec.templates` in order to provide a reason for the manifest change. This is something that would be template driven by your CD system.

    annotations: 
        kubernetes.io/ change-cause: 'Data changed in API, updating to 2.0'

Then apply your change:

    kubectl apply -f templates/api-deployments.yaml

Then observe the state change to the list of pods every second using the `watch` command:

    watch -n 1 kubectl get pods

Observe the deployment history:

    kubectl rollout history deployment/api-deployment
