#!/bin/bash

target=target
declare -A kvs=()

function replace_files() {
    local file=$1
    if [ -f $file ];then
        echo "$file"
        for key in ${!kvs[@]}
        do
            value=${kvs[$key]}
            value=${value//\//\\\/}
            sed -i "s/{{$key}}/${value}/g" $file
        done
        return 0
    fi
    if [ -d $file ];then
        for f in `ls $file`
        do
            replace_files "${file}/${f}"
        done
    fi
    return 0
}

rm -fr $target
mkdir -p $target
cp -r pki $target
cp -r configs $target
cp -r addons $target
cp -r services $target
cd $target

echo "====替换变量列表===="
while read line;do
    if [ "${line:0:1}" == "#" -o "${line:0:1}" == "" ];then
        continue;
    fi
    key=${line/=*/}
    value=${line#*=}
    echo "$key=$value"
    kvs["$key"]="$value"
done < ../global-config.properties

echo -e "\n====替换证书配置文件===="
replace_files pki

echo -e "\n====替换配置文件===="
replace_files configs

replace_files addons

#workers
BACKUP_IFS=$IFS
IFS=','
worker_ips=(${kvs["WORKER_IPS"]})
IFS=$BACKUP_IFS
for i in ${!worker_ips[@]}
do
    ip=${worker_ips[$i]}
    mkdir "worker-$ip"
    kvs["NODE_IP"]=$ip
    cp configs/kubelet.config.yaml "worker-$ip"
    cp services/kubelet.service "worker-$ip"
    cp configs/kube-proxy.config.yaml "worker-$ip"
    cp services/kube-proxy.service "worker-$ip"
    cp services/etcd.service "worker-$ip"
    replace_files "worker-$ip"
done

echo -e "\n====替换service文件===="

DIR=${kvs["MASTER_1_IP"]}
mkdir "master-$DIR"
cp -r services/{kube-apiserver.service,kube-controller-manager.service,kube-scheduler.service} "master-$DIR"
replace_files "master-$DIR"

DIR=${kvs["MASTER_2_IP"]}
mkdir "master-$DIR"
cp -r services/{kube-apiserver.service,kube-controller-manager.service,kube-scheduler.service} "master-$DIR"
replace_files "master-$DIR"

DIR=${kvs["ETCD_1_IP"]}
mkdir "etcd-$DIR"
cp -r services/etcd.service "etcd-$DIR"
kvs["NODE_IP"]=$DIR
kvs["NODE_NAME"]=${kvs["ETCD_1_HOSTNAME"]}
replace_files "etcd-$DIR"

DIR=${kvs["ETCD_2_IP"]}
mkdir "etcd-$DIR"
cp -r services/etcd.service "etcd-$DIR"
kvs["NODE_IP"]=$DIR
kvs["NODE_NAME"]=${kvs["ETCD_2_HOSTNAME"]}
replace_files "etcd-$DIR"

DIR=${kvs["ETCD_3_IP"]}
mkdir "etcd-$DIR"
cp -r services/etcd.service "etcd-$DIR"
kvs["NODE_IP"]=$DIR
kvs["NODE_NAME"]=${kvs["ETCD_3_HOSTNAME"]}
replace_files "etcd-$DIR"


replace_files services

echo "配置生成成功，位置: `pwd`"
