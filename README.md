# Learn Kubernetes

This repository will help you learn the basics of working with Kubernetes by taking you through the fundamental building blocks.

## System Requirements

 - make 
 - Docker for Mac/Windows
 
## Setup

This repository depends on images that are built using the `https://github.com/ryan-blunden/learn-docker` repository.

To build the required images:

    cd /tmp
    git clone https://github.com/ryan-blunden/learn-docker
    cd learn-docker
    make build
    cd ../
    rm -fr learn-docker
