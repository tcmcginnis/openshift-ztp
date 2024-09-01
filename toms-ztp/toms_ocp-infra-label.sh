#!/bin/bash 

#m6i.2xlarge
# oc get nodes
#https://red-hat-storage.github.io/ocs-training/training/infra-nodes/ocs4-infra-nodes.html
# https://docs.openshift.com/container-platform/4.11/machine_management/creating-infrastructure-machinesets.html#infrastructure-moving-router_creating-infrastructure-machinesets
# https://access.redhat.com/documentation/en-us/red_hat_advanced_cluster_management_for_kubernetes/2.8/html/install/installing#tolerations
# https://github.com/OpenShiftDemos/openshift-ops-workshops/blob/ocp4-dev/workshop/content/infra-nodes.adoc
array=( $(oc get nodes|grep odf|awk '{print $1}'|xargs echo))
# array=( lab-worker-0 lab-worker-1 lab-worker-2 )
for i in "${array[@]}"
do
    echo "$i"
    oc label node $i node-role.kubernetes.io/infra=""
    oc label node $i cluster.ocs.openshift.io/openshift-storage=""
    #oc adm taint node $i node.ocs.openshift.io/storage="true":NoSchedule # if you only want these nodes to run storage pods
done

oc patch configs.imageregistry.operator.openshift.io/cluster -p '{"spec":{"nodeSelector":{"node-role.kubernetes.io/infra": ""}}}' --type=merge
oc patch ingresscontroller/default -n  openshift-ingress-operator  --type=merge -p '{"spec":{"nodePlacement": {"nodeSelector": {"matchLabels": {"node-role.kubernetes.io/infra": ""}},"tolerations": [{"effect":"NoSchedule","key": "node-role.kubernetes.io/infra","value": "reserved"},{"effect":"NoExecute","key": "node-role.kubernetes.io/infra","value": "reserved"}]}}}'
oc patch -n openshift-ingress-operator ingresscontroller/default --patch '{"spec":{"replicas": 3}}' --type=merge
# oc patch storageclass ocs-storagecluster-cephfs -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
# oc patch storageclass ocs-storagecluster-ceph-rbd -p '{"metadata": {"annotations":{"storageclass.kubernetes.io/is-default-class":"true"}}}'
