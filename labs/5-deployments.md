# Deployments

Create the deployment object:

    kubectl create -f templates/api-deployments.yaml

Validate its creation:

    kubectl get deployments
    kubectl describe deployment api-deployment

Build a new version of the api container:

    make api-build VERSION=2.0

Now update your `api-deployments.yaml` file, changing the image tag to `2.0` and perthaps, changing replicas to a different number also.

Then apply your change:

    kubectl apply -f templates/api-deployments.yaml

Then observe the state change to the list of pods:

    kubectl get pods

Observe the deployment history:

    kubectl rollout history deployment/api-deployment

