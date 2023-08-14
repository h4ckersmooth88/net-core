kubectl create serviceaccount jenkins-admin -n kube-system
kubectl create clusterrolebinding jenkins-admin --serviceaccount=kube-system:jenkins-admin --clusterrole=cluster-admin
SECRET=$(kubectl get serviceaccount jenkins-admin -n kube-system -o jsonpath='{.secrets[].name}')
TOKEN=$(kubectl get secret $SECRET -n kube-system -o jsonpath='{.data.token}' | base64 -d)
kubectl get secrets $SECRET -n kube-system -o jsonpath='{.data.ca\.crt}' | base64 -d > ./ca.crt
CONTEXT=$(kubectl config view -o jsonpath='{.current-context}')
CLUSTER=$(kubectl config view -o jsonpath='{.contexts[?(@.name == "'"$CONTEXT"'")].context.cluster}')
URL=$(kubectl config view -o jsonpath='{.clusters[?(@.name == "'"$CLUSTER"'")].cluster.server}')
NON_EXPIRING_KUBECONFIG_FILE="kubeconfig"
kubectl config --kubeconfig=$NON_EXPIRING_KUBECONFIG_FILE set-cluster $CLUSTER --server=$URL --certificate-authority=./ca.crt --embed-certs=true
kubectl config --kubeconfig=$NON_EXPIRING_KUBECONFIG_FILE set-credentials jenkins-admin --token=$TOKEN
kubectl config --kubeconfig=$NON_EXPIRING_KUBECONFIG_FILE set-context $CONTEXT --cluster=$CLUSTER --user=jenkins-admin
kubectl config --kubeconfig=$NON_EXPIRING_KUBECONFIG_FILE use-context $CONTEXT
