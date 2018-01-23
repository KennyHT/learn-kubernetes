# Minikube Development Environment Setup

We want to avoid having to setup a local registry for K8s to talk to so we make the Docker CLI point to Minikube.

This way, we can build locally and have Kubernetes use the new image instantly without a push to and pull from a registry.

Point Docker CLI at Minikube:

    eval $(minikube docker-env)

Verify it works:

    docker image ls

Build our API image:

    make api-build

Can we see the newly created image in minikube?

    docker image ls | grep training.io/api
