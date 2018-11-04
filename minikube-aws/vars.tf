variable "region" {}
variable "vpc_id" {}

variable "subnet_id" {}

variable "key_name" {
    default = "minikube"
}

variable "name" {}

variable "ingress_cidr" {
    default = "0.0.0.0/0"
}

variable "instance_type" {
    default = "t2.large"
}

