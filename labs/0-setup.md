# Development Environment Setup

These instructions are currently for MacOS users with [homebrew](https://brew.sh/) installed. Linux users will be able to easily get the same results while Windows 10 users will have to use a Linux VM or the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

Windows users are encouraged to install the [Windows Subsystem for Linux](https://docs.microsoft.com/en-us/windows/wsl/install-win10).

## Docker for Desktop

Download and install [Docker for Desktop](https://www.docker.com/products/docker-desktop).

If you're on Linux, [then this guide using kubeadm](https://medium.com/@lizrice/kubernetes-in-vagrant-with-kubeadm-21979ded6c63) by Kubernetes super star Liz Rice (even though she uses the VM from her Mac) should work like a charm.

## Kubectl Proxy

For easy access to services running in your development environment, you can use kubectl proxy.

    kubectl proxy

You can now access services throgh the tunnel exposed on localhost port 8001.

See [this page from the Kubernetes docs](https://kubernetes.io/docs/tasks/administer-cluster/access-cluster-services/#manually-constructing-apiserver-proxy-urls) for learning how to manually construct links to your services.

## Required images

To save some time during the class, you can run `make setup` to pull down the two required images for these labs.

    make setup

## The watch command

The watch command allows you to observe the output from running a command every n seconds.

While kubernetes has a built-in `--watch` flag, I often don't use it as it doesnt't flush the previous output.

To install it with homebrew on the Mac, use `brew install watch`.

## Bash completion for kubectl

The kubectl CLI is huge and the completion functionality will help save time and help you learn.

For this to work, you need `bash-completion` installed by homebrew by running:

    brew install bash-completion

Then add this to your ~/.bash_profile:

    [ -f /usr/local/etc/bash_completion ] && . /usr/local/etc/bash_completion

Then install the completion for kubectl.

    kubectl completion bash > $(brew --prefix)/etc/bash_completion.d/kubectl
