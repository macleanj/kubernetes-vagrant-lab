#!/bin/bash
programName=$(basename "$0")
programDir=$(dirname "$0")

KUBECONFIG_FILE="kubeconfig_cluster-admin-vagrant.yml"
vagrant scp master-0:~/.kube/config ./$KUBECONFIG_FILE
sed -i -e 's|kubernetes|vagrant-lab|g' "${KUBECONFIG_FILE}"
sed -i -e 's|vagrant-lab-admin|cluster-admin|g' "${KUBECONFIG_FILE}"

echo ""
echo "Run the following command to source KUBECONFIG:"
echo "export KUBECONFIG=$programDir/$KUBECONFIG_FILE"
