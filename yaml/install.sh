

kubectl create sa jenkins-deployer
kubectl create clusterrolebinding jenkins-deployer-role — clusterrole=cluster-admin — serviceaccount=jenkins-deployer
