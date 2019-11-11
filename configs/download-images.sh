#!/bin/bash

docker pull calico/node:v3.10.1-2-g1d542f3-amd64
docker tag calico/node:v3.10.1-2-g1d542f3-amd64 calico/node:v3.10.1
docker rmi calico/node:v3.10.1-2-g1d542f3-amd64

docker pull calico/cni:v3.10.1-2-gf2a76e2-amd64
docker tag calico/cni:v3.10.1-2-gf2a76e2-amd64 calico/cni:v3.10.1
docker rmi calico/cni:v3.10.1-2-gf2a76e2-amd64

docker pull calico/typha:v3.10.1-2-g492ca4c-amd64
docker tag calico/typha:v3.10.1-2-g492ca4c-amd64 calico/typha:v3.10.1
docker rmi calico/typha:v3.10.1-2-g492ca4c-amd64



docker pull registry.cn-hangzhou.aliyuncs.com/liuyi01/pause-amd64:3.1
docker tag registry.cn-hangzhou.aliyuncs.com/liuyi01/pause-amd64:3.1 k8s.gcr.io/pause-amd64:3.1
docker rmi registry.cn-hangzhou.aliyuncs.com/liuyi01/pause-amd64:3.1

docker pull coredns/coredns:1.6.4
docker tag coredns/coredns:1.6.4 k8s.gcr.io/coredns:1.6.4
docker rmi coredns/coredns:1.6.4

docker pull registry.cn-hangzhou.aliyuncs.com/liuyi01/kubernetes-dashboard-amd64:v1.8.3
docker tag registry.cn-hangzhou.aliyuncs.com/liuyi01/kubernetes-dashboard-amd64:v1.8.3 k8s.gcr.io/kubernetes-dashboard-amd64:v1.8.3
docker rmi registry.cn-hangzhou.aliyuncs.com/liuyi01/kubernetes-dashboard-amd64:v1.8.3
