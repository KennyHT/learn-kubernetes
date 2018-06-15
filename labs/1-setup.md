# Development Environment Setup

These instructions are currently for MacOS users with [homebrew](https://brew.sh/) installed. Linux users will be able to easily get the same results while Windows 10 users will have to use a Linux VM or the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

## Docker for Mac/Widows Edge Edition

At time of writing (April 2018), the Edge edition is still required for getting the Kubernetes integrated version of Docker for Desktop. More info at https://www.docker.com/kubernetes

## Kubernetes Dashboard

The Kubernetes dashboard is a vital tool, particularly when learning Kubernetes.

Deploy the Kubernetes Dashboard

    kubectl apply -f https://raw.githubusercontent.com/kubernetes/dashboard/master/src/deploy/recommended/kubernetes-dashboard.yaml

Then, we need to setup port forwarding so we can access the Dashboard from outside the Kubernetes cluster (running on the Docker for Desktop Linux VM).

The `kubectl port-forward` command requires the name of the Kubernetes Dashboard Pod so lets get that.

    # Windows
    kubectl get pods --namespace kube-system | findstr kubernetes-dashboard

    # Mac
    kubectl get pods --namespace kube-system | grep kubernetes-dashboard

Then setup the port-forwarding.

    kubectl port-forward <POD NAME> 30000:8443 --namespace kube-system

Now you can access the dashboard at [https://localhost:30000/](https://localhost:30000/).

If you're on a Mac or Windows using the WSL, you can use the bash code at this [GitHub Gist](https://gist.github.com/ryan-blunden/86f14deea43b79058882dda764c38650) to give you two functions for starting and stopping the Kubernetes Dashboard.

## Required images

These labs depends on images that are built using the `https://github.com/ryan-blunden/learn-docker` repository.

To build the required images:

    make build

## The watch command

The watch command allows you to observe the output from running a command every n seconds.

To install it with homebrew, use `brew install watch`.

## Bash completion for kubectl

The kubectl CLI is huge and the completion functionality will help save time and help you learn.

For this to work, you need `bash-completion` installed by homebrew by running:

    brew install bash-completion

Then add this to your ~/.bash_profile:

    [ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

Then install the completion for kubectl.

    kubectl completion bash > $(brew --prefix)/etc/bash_completion.d/kubectl
